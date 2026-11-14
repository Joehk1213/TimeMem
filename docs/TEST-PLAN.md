---
title: TimeMem M0 Test Plan
date: 2026-11-12
status: Draft
---

# Test Plan

Tests are planned only; no product acceptance is claimed. Pass criteria come from [REQUIREMENTS.md](./REQUIREMENTS.md), not from this plan.

## Unit Tests

- TBD until product code exists and M0 scope is approved. Add each test with its REQ-ID before implementation.

## Integration Tests

- TBD until the approved architecture and product code exist. Trace each component-boundary test to a REQ-ID; do not test draft scope as an accepted requirement.

## Manual UAT

| Test | Requirement | Procedure | Pass evidence |
|---|---|---|---|
| T-001 | REQ-001 | Follow the clean-device procedure in [TimeMem-Install-SOP-Lock-Version.md](./TimeMem-Install-SOP-Lock-Version.md) on JOE-SERVER. | One completed checklist and date recorded in M0-READY. |
| T-002 | REQ-002 | Run the approved one-click installer in [TimeMem-Install-SOP-Lock-Version.md](./TimeMem-Install-SOP-Lock-Version.md) once. | One successful installer result recorded in M0-READY. |
| T-003 | REQ-003 | Verify every check in [TimeMem-Install-SOP-Lock-Version.md](./TimeMem-Install-SOP-Lock-Version.md). | All SOP checks pass; result recorded in M0-READY. |
| T-004 | REQ-004 | Follow [TimeMem-Home-Hub-Physical-Setup.md](./TimeMem-Home-Hub-Physical-Setup.md) and verify router-side placement and connection. | One placement result recorded in M0-READY. |
| T-005 | REQ-005 | Restart once after installation and observe the local application endpoint. | Endpoint opens without manual launch; result recorded in M0-READY. |
| T-006 | REQ-006 | From one authorized Tailnet device outside the home LAN, open the HTTPS endpoint; repeat from one external non-Tailnet device. | Tailnet request succeeds, non-Tailnet request is unreachable, and no router port is open; record both results. |
| T-007 | REQ-007 | On the authorized remote device, open the PWA through the Tailnet endpoint once. | App shell renders; no login, Calendar, or data operation is required. |

## Acceptance Criteria

- T-001 through T-007 map one-to-one to REQ-001 through REQ-007. The PWA test is shell-only; AI, login, device remembrance, Calendar, Always-on behavior, and offline-LAN tests are outside M0.

## Later Tests — Approved Product Policies

These are planned future-milestone tests, not M0 acceptance. Use synthetic records, test accounts, and authorized test devices; do not include household personal data in test evidence.

| Test | Procedure | Pass evidence |
|---|---|---|
| P-001 — Confidence tiers | Exercise S2/S8/S9 proposals at values below 0.7, at 0.7 and 0.9, and above 0.9. Verify low confidence never writes and asks for clarification; the middle tier requires confirmation; the high tier auto-executes only where the feature policy permits it. Verify features that explicitly require confirmation, including photo linking, still request confirmation. | Recorded input, confidence, proposed action, confirmation state, and DB result demonstrate the same thresholds and feature-specific confirmation rules. |
| P-002 — Undo boundary | Create multiple event/todo updates in one session, including automatic and confirmed updates. Undo within 30 seconds; verify LIFO order and that only the latest un-undone update is reversed. Verify another session cannot undo them, memories/deletions are excluded, and an expired Undo is unavailable. | Before/after records and timestamps show the 30-second limit, same-session scope, LIFO behavior, and excluded data types. |
| P-003 — PIN lockout | With a test account, verify the failure counter resets only on successful login. The 5th consecutive failure locks for 5 minutes; after expiry, five more consecutive failures without a successful login reach 10 total and lock for 10 minutes with the required message and log entry. Inputs during either lock are logged but do not count. After reaching 10, each further failed attempt after lock expiry repeats the 10-minute lock. Verify no automatic notification is sent. | Timestamped lockout results and redacted logs prove counter retention/reset, both lock durations, locked-input handling, the message, repeated 10-minute lock and absence of automatic notification. |
| P-004 — Tailnet privacy and cache | From an authorized remote test device, view synthetic household records only over encrypted Tailnet. Inspect local cache storage for encryption; log out and separately revoke the device/session, then verify the cache is cleared. Verify the POC/public Cloud cannot receive the test household records. | Network/access evidence, cache inspection, and post-logout/revocation checks demonstrate the approved boundary without exposing secrets or personal data. |
| P-005 — Teach file Undo | In one session, perform multiple teach operations. Before each, verify a snapshot exists for `nlp-synonyms.json`, `reminder-defaults.json`, and `teach-log.md`. Undo each operation within 30 seconds in reverse order; verify each restores the corresponding pre-teach file snapshot and does not issue a DB Item restore. | File hashes/content and session/timestamp evidence prove pre-change snapshots, 30-second limit, same-session LIFO order, and file-only restoration. |

P-002 covers event/todo record Undo; P-005 covers the distinct S10 teach-file Undo. They are separate LIFO histories and must not be treated as one shared Item/file undo operation.

M6 SHARE has no committed scope, timing, delivery, or acceptance criteria; it must not be reported as a release acceptance item unless separately approved.

## Later Tests — Backup and Restore

These are planned, not executed or part of M0. D-007 requires encrypted nightly backups retained for 30 days and a weekly full restore verification to a temporary DB; a backup is not PASS merely because a file was created. D-018 and D-019 remain Draft. Exact age / Argon2 design and key management need separate approval: do not assume age natively uses Argon2 or equate PIN hashing with backup encryption.

| Test | Procedure | Pass evidence |
|---|---|---|
| B-001 — Complete backup | Use synthetic DB records, relationships and synthetic photos; record a consistent DB dump plus originals and thumbnails as one backup set and record file counts and hashes. Encrypt using the approved future method and separate test key. | All intended DB and file components are present and identifiable as the same backup point; no plaintext secret or test key in evidence. |
| B-002 — Isolated recovery | Decrypt with the correct test key; restore the entire dump to an isolated temporary DB and files to an isolated temporary directory, never the Primary. Compare representative records, relationships, counts and file hashes against the backup manifest; open representative files. | Decryption, complete restore and all comparisons succeed; record date, backup identifier and results. |
| B-003 — Failure handling | Separately try a wrong key, a corrupted or missing backup component, inconsistent DB/file set, insufficient space and an interrupted restore using disposable test resources. | Each failure is explicit, produces no success/PASS and does not change the Primary. Record the failure without passwords, keys or personal data. |
| B-004 — Key recovery and repeatability | Using test keys only, exercise the separately held key and paper recovery procedure; repeat the full isolated restore on the D-007 weekly schedule when the future procedure exists. | Authorized recovery works without the live Primary or same-D: key storage; each run records outcome and failures. Clean up only the isolated test resources afterwards. |

Use synthetic data and separate test credentials throughout. A real offline-media copy and conflict reapply procedure are not approved by D-019 / D-018; do not claim these tests implement or verify those proposals.

## Later Tests — Track Separation

Before any public POC use, test with synthetic fixtures that POC identity and authorization controls work, datasets and credentials are separate, and the household Primary is unreachable from the POC. Inspect intended upload, embedding, model, log and backup paths for accidental household-data transfer; document limitations and explicit failures. Design of these controls and acceptance thresholds is TBD; no public security or isolation PASS is claimed.
