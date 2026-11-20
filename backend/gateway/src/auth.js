import { query } from "./db.js";
import { createSessionToken, hashPin, tokenHash, validatePin, verifyPin } from "./security.js";

const SESSION_COOKIE = "timemem_session";
const SESSION_DAYS = 30;

export async function bootstrapOwner() {
  const pin = process.env.TIMEMEM_BOOTSTRAP_PIN;
  if (!pin) return;
  if (!validatePin(pin)) throw new Error("TIMEMEM_BOOTSTRAP_PIN must contain exactly six digits");
  const pinHash = await hashPin(pin);
  await query(
    `WITH family AS (
       INSERT INTO families (id, name) VALUES ('00000000-0000-4000-8000-000000000001', 'TimeMem Family')
       ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name
       RETURNING id
     )
     INSERT INTO members (id, family_id, display_name, role, pin_hash)
     VALUES ('00000000-0000-4000-8000-000000000002', (SELECT id FROM family), 'Joe', 'owner', $1)
     ON CONFLICT (id) DO UPDATE SET pin_hash = EXCLUDED.pin_hash, deleted_at = NULL`,
    [pinHash]
  );
  console.log(JSON.stringify({ event: "bootstrap_owner_ready" }));
}

export async function memberFromToken(rawToken) {
  if (!rawToken) return null;
  const result = await query(
    `SELECT m.id, m.family_id, m.display_name, m.role
       FROM app_sessions s
       JOIN members m ON m.id = s.member_id
      WHERE s.token_hash = $1
        AND s.expires_at > now()
        AND s.revoked_at IS NULL
        AND m.deleted_at IS NULL`,
    [tokenHash(rawToken)]
  );
  return result.rows[0] || null;
}

export async function requireAuth(req, res, next) {
  try {
    const member = await memberFromToken(req.cookies[SESSION_COOKIE]);
    if (!member) {
      return res.status(401).json({ error: { code: "AUTH_REQUIRED", message: "登入後再試。" } });
    }
    req.member = member;
    next();
  } catch (error) {
    next(error);
  }
}

export async function login(req, res) {
  const { memberId, pin } = req.body || {};
  if (!validatePin(pin) || typeof memberId !== "string") {
    return res.status(400).json({ error: { code: "INVALID_LOGIN", message: "需要 memberId 及 6 位數 PIN。" } });
  }

  const result = await query(
    `SELECT id, family_id, display_name, role, pin_hash, failed_pin_attempts, locked_until
       FROM members WHERE id = $1 AND deleted_at IS NULL`,
    [memberId]
  );
  const member = result.rows[0];
  if (!member || !member.pin_hash) {
    return res.status(401).json({ error: { code: "INVALID_CREDENTIALS", message: "帳戶或 PIN 不正確。" } });
  }
  if (member.locked_until && new Date(member.locked_until) > new Date()) {
    return res.status(423).json({ error: { code: "ACCOUNT_LOCKED", message: "帳戶暫時鎖定。" } });
  }
  if (!(await verifyPin(pin, member.pin_hash))) {
    const failed = await query(
      `UPDATE members
          SET failed_pin_attempts = failed_pin_attempts + 1,
              locked_until = CASE
                WHEN failed_pin_attempts + 1 >= 10 THEN now() + interval '10 minutes'
                WHEN failed_pin_attempts + 1 = 5 THEN now() + interval '5 minutes'
                ELSE locked_until END
        WHERE id = $1
        RETURNING failed_pin_attempts`,
      [member.id]
    );
    const code = failed.rows[0].failed_pin_attempts >= 10 ? "CONTACT_OWNER" : "INVALID_CREDENTIALS";
    return res.status(401).json({ error: { code, message: "帳戶或 PIN 不正確。" } });
  }

  await query("UPDATE members SET failed_pin_attempts = 0, locked_until = NULL WHERE id = $1", [member.id]);
  const token = createSessionToken();
  await query(
    "INSERT INTO app_sessions (token_hash, member_id, expires_at) VALUES ($1, $2, now() + interval '30 days')",
    [tokenHash(token), member.id]
  );
  res.cookie(SESSION_COOKIE, token, {
    httpOnly: true,
    sameSite: "strict",
    secure: process.env.NODE_ENV === "production",
    maxAge: SESSION_DAYS * 24 * 60 * 60 * 1000,
    path: "/"
  });
  res.json({ member: { id: member.id, familyId: member.family_id, displayName: member.display_name, role: member.role } });
}

export async function logout(req, res) {
  const token = req.cookies[SESSION_COOKIE];
  if (token) {
    await query("UPDATE app_sessions SET revoked_at = now() WHERE token_hash = $1", [tokenHash(token)]);
  }
  res.clearCookie(SESSION_COOKIE, { path: "/" });
  res.status(204).end();
}

export async function currentSession(req, res) {
  res.json({ member: req.member });
}
