import crypto from "node:crypto";
import { promisify } from "node:util";

const scrypt = promisify(crypto.scrypt);

export function validatePin(pin) {
  return typeof pin === "string" && /^\d{6}$/.test(pin);
}

export async function hashPin(pin) {
  if (!validatePin(pin)) throw new Error("PIN must contain exactly six digits");
  const salt = crypto.randomBytes(16).toString("hex");
  const derived = await scrypt(pin, salt, 64);
  return `scrypt:${salt}:${derived.toString("hex")}`;
}

export async function verifyPin(pin, encoded) {
  if (!validatePin(pin) || typeof encoded !== "string") return false;
  const [algorithm, salt, expected] = encoded.split(":");
  if (algorithm !== "scrypt" || !salt || !expected) return false;
  const actual = await scrypt(pin, salt, 64);
  const expectedBuffer = Buffer.from(expected, "hex");
  return actual.length === expectedBuffer.length && crypto.timingSafeEqual(actual, expectedBuffer);
}

export function tokenHash(token) {
  const secret = process.env.TIMEMEM_SESSION_SECRET;
  if (!secret || secret.length < 24) throw new Error("TIMEMEM_SESSION_SECRET must be at least 24 characters");
  return crypto.createHmac("sha256", secret).update(token).digest("hex");
}

export function createSessionToken() {
  return crypto.randomBytes(32).toString("base64url");
}

export function canAccessRecord(member, row) {
  return member.role === "owner" || row.visibility === "shared" || row.created_by === member.id;
}
