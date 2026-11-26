---
title: TimeMem M0 Requirements
date: 2026-11-12
status: Draft
---

# Requirements

## Authority and Status

These requirements reflect the scope approved in CR-002 / D-023, but remain Draft pending the M0 reviews and approval. CR-004 / D-025 records product direction without changing REQ-001–REQ-007. Source order follows the New-Start-Project-Framework: Requirements, Decisions, Architecture, Test Plan, Risks, then GATE.

## In Scope

- **REQ-001 — Prepare JOE-SERVER:** Complete and record one clean-device checklist for the PRD M0 target.
- **REQ-002 — Install:** One invocation of the approved installer on JOE-SERVER completes successfully.
- **REQ-003 — Server Lock:** Every check in the approved Server Lock SOP passes.
- **REQ-004 — Physical placement:** One installation is verified at the router-side location specified by the approved setup SOP.
- **REQ-005 — Automatic start:** After one restart, TimeMem starts and opens its local application endpoint without manual launch.
- **REQ-006 — Tailnet remote reachability:** From one authorized device outside the home LAN, the HTTPS endpoint is reachable over Tailnet; from one external non-Tailnet device, it is unreachable. No router port is opened.
- **REQ-007 — PWA shell:** On the authorized remote device, the PWA app shell opens once through the Tailnet endpoint. This does not include login, Calendar, or data access.

## Out of Scope

- AI natural-language input, confidence behavior, Undo, and Ollama fallback are later-milestone work; AI input begins in M2. MCP client direction is approved in D-027, while transport, connector and milestone details remain pending. Household Passkey/login is M4 and Face ID is M5; device remembrance and direct Calendar entry are later-milestone items whose exact placement remains TBD.
- PWA reminders, Tailnet Always-on / On-demand behavior, and offline-LAN operation are not included in M0.
- A public Cloud POC and its Supabase Auth are not M0 acceptance items. Household data, DB and inference remain local; household router ports are not opened and the household track never falls back to external LLM services (D-025).

## Product Direction Beyond M0

- Preserve all PRD S1–S10 goals. Reminders are a core need; Calendar, TODO and photos are early priorities, while identity documents and files are later. This does not add M0 acceptance items.
- Public POC: Supabase / Cloud with Supabase Auth, exclusively synthetic/test data. Real household data and derived copies, attachments, embeddings, logs, backups and model inputs must never be sent to public Cloud, the POC or external services. Authorized remote viewing is limited to encrypted Tailnet connections to authorized devices; device caches must be encrypted and cleared on logout or device/session revocation. Keep environments, credentials and datasets isolated; POC security details remain to be designed and verified.
- Household closed loop: the household PostgreSQL + pgvector and inference remain local; authorized remote viewing may use encrypted Tailnet connections to authorized devices, with encrypted caches cleared on logout or device/session revocation. Local Passkey / PIN remains the target. No public POC integration may expose the household Primary.
- Finance expense recording and eventual statistics / analysis remain desired; statistics / analysis is Later, phase TBD. Smart home and Space are TBD. Multi-Agent is a future concept only, not a commitment to implement it or avoid future code changes.
- FR-10 now records TimeMem as an outbound read-only MCP client direction (D-027). Connector transport, credentials, allowlist, audit, revoke and milestone remain pending; it is not a current M0 commitment.

## M0 Success Criteria

- REQ-001 through REQ-007 each pass once, with an observable result and evidence recorded in GATE; all seven must pass.
- Operational steps belong to the approved installation and physical-setup SOPs; this requirements file defines the result, not the step-by-step procedure.

## Scope Decision

- CR-002 is Approved by Joe and recorded as D-023: M0 is the five PRD setup items plus REQ-006 and REQ-007. The deferred features above are not M0 acceptance criteria.
- CR-004 / D-025 records the two-track direction and supersedes the earlier MCP timing/design only; it is not M0 approval.
- D-015 is Approved as a later-milestone Undo policy for event/todo records and teach-file snapshots; teach Undo restores files, not DB Items. It is not an M0 implementation requirement. D-016 through D-022 remain Draft proposals and are not M0 implementation requirements.

## Assumptions

- JOE-SERVER is the M0 installation target; it is not yet SETUP or READY.
- Joe must identify the one supported remote phone / OS / browser used for REQ-006 and REQ-007 before UAT.
- No product code, migration, or product database is created before M0 approval.