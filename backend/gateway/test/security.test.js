import assert from "node:assert/strict";
import test from "node:test";
import { canAccessRecord, hashPin, validatePin, verifyPin } from "../src/security.js";

test("PIN hashing only accepts six digits and verifies", async () => {
  assert.equal(validatePin("123456"), true);
  assert.equal(validatePin("12345"), false);
  const encoded = await hashPin("123456");
  assert.equal(await verifyPin("123456", encoded), true);
  assert.equal(await verifyPin("654321", encoded), false);
});

test("role and private-record access follows the family policy", () => {
  const owner = { id: "owner", role: "owner" };
  const adult = { id: "adult", role: "adult" };
  const privateRecord = { created_by: "other", visibility: "private" };
  assert.equal(canAccessRecord(owner, privateRecord), true);
  assert.equal(canAccessRecord(adult, privateRecord), false);
  assert.equal(canAccessRecord(adult, { created_by: "adult", visibility: "private" }), true);
  assert.equal(canAccessRecord(adult, { created_by: "other", visibility: "shared" }), true);
});
