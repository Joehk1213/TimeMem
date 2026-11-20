import { randomUUID } from "node:crypto";
import { query } from "./db.js";

const definitions = {
  events: {
    fields: ["title", "description", "starts_at", "ends_at", "visibility"],
    required: ["title"]
  },
  todos: {
    fields: ["title", "details", "due_at", "completed_at", "visibility"],
    required: ["title"]
  }
};

function authorizeType(type) {
  const definition = definitions[type];
  if (!definition) {
    const error = new Error("Unknown record type");
    error.status = 404;
    throw error;
  }
  return definition;
}

function accessClause(memberParam = "$2", roleParam = "$3") {
  return `(visibility = 'shared' OR created_by = ${memberParam} OR ${roleParam} = 'owner')`;
}

export async function listRecords(req, res, next) {
  try {
    authorizeType(req.params.type);
    const result = await query(
      `SELECT * FROM ${req.params.type}
        WHERE family_id = $1 AND deleted_at IS NULL AND ${accessClause()}
        ORDER BY created_at DESC LIMIT 200`,
      [req.member.family_id, req.member.id, req.member.role]
    );
    res.json({ items: result.rows });
  } catch (error) {
    next(error);
  }
}

export async function getRecord(req, res, next) {
  try {
    authorizeType(req.params.type);
    const result = await query(
      `SELECT * FROM ${req.params.type}
        WHERE id = $1 AND family_id = $2 AND deleted_at IS NULL
          AND (visibility = 'shared' OR created_by = $3 OR $4 = 'owner')`,
      [req.params.id, req.member.family_id, req.member.id, req.member.role]
    );
    if (!result.rows[0]) return res.status(404).json({ error: { code: "NOT_FOUND", message: "Record not found." } });
    res.json({ item: result.rows[0] });
  } catch (error) {
    next(error);
  }
}

export async function createRecord(req, res, next) {
  try {
    const definition = authorizeType(req.params.type);
    for (const field of definition.required) {
      if (typeof req.body?.[field] !== "string" || !req.body[field].trim()) {
        return res.status(422).json({ error: { code: "VALIDATION_ERROR", message: `${field} is required.` } });
      }
    }
    const fields = definition.fields.filter((field) => req.body[field] !== undefined);
    const values = fields.map((field) => req.body[field]);
    const id = randomUUID();
    const columns = ["id", "family_id", "created_by", ...fields];
    const placeholders = columns.map((_, index) => `$${index + 1}`);
    const result = await query(
      `INSERT INTO ${req.params.type} (${columns.join(", ")}) VALUES (${placeholders.join(", ")}) RETURNING *`,
      [id, req.member.family_id, req.member.id, ...values]
    );
    req.recordChange?.({ action: "created", type: req.params.type, id });
    res.status(201).json({ item: result.rows[0] });
  } catch (error) {
    next(error);
  }
}

export async function updateRecord(req, res, next) {
  try {
    const definition = authorizeType(req.params.type);
    const fields = definition.fields.filter((field) => req.body?.[field] !== undefined);
    if (!fields.length) {
      return res.status(422).json({ error: { code: "VALIDATION_ERROR", message: "No editable fields supplied." } });
    }
    const updates = fields.map((field, index) => `${field} = $${index + 1}`);
    const result = await query(
      `UPDATE ${req.params.type} SET ${updates.join(", ")}, updated_at = now()
        WHERE id = $${fields.length + 1} AND family_id = $${fields.length + 2}
          AND deleted_at IS NULL AND ${accessClause(`$${fields.length + 3}`, `$${fields.length + 4}`)}
        RETURNING *`,
      [...fields.map((field) => req.body[field]), req.params.id, req.member.family_id, req.member.id, req.member.role]
    );
    if (!result.rows[0]) return res.status(404).json({ error: { code: "NOT_FOUND", message: "Record not found." } });
    req.recordChange?.({ action: "updated", type: req.params.type, id: req.params.id });
    res.json({ item: result.rows[0] });
  } catch (error) {
    next(error);
  }
}

export async function deleteRecord(req, res, next) {
  try {
    authorizeType(req.params.type);
    const result = await query(
      `UPDATE ${req.params.type} SET deleted_at = now(), updated_at = now()
        WHERE id = $1 AND family_id = $2 AND deleted_at IS NULL
          AND (created_by = $3 OR $4 = 'owner') RETURNING id`,
      [req.params.id, req.member.family_id, req.member.id, req.member.role]
    );
    if (!result.rows[0]) return res.status(404).json({ error: { code: "NOT_FOUND", message: "Record not found." } });
    req.recordChange?.({ action: "deleted", type: req.params.type, id: req.params.id });
    res.status(204).end();
  } catch (error) {
    next(error);
  }
}
