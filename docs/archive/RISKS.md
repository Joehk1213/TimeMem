---
title: TimeMem M0 Risks
date: 2026-11-12
status: Draft
---

# Risks

### Risk R-001
- Risk: PRD and M0 implementation scope could diverge.
- Impact: High — implementation or approval may cover the wrong milestone.
- Mitigation: Joe resolved the M0 boundary in CR-002 / D-023; keep Requirements, Test Plan, and GATE aligned with that decision.
- Owner: Joe
- Status: Closed

### Risk R-002
- Risk: JOE-SERVER is the normal single writable Primary and is not yet READY.
- Impact: High — hardware or storage failure may interrupt service or risk data.
- Mitigation: Complete and verify the approved backup and recovery procedure before relying on the service; D-016 and D-019 remain Draft.
- Owner: Joe
- Status: Open

### Risk R-003
- Risk: Restore conflict handling and post-recovery session handling are not approved.
- Impact: High — restore may omit or overwrite data, or retain stale sessions.
- Mitigation: Approve and test D-018 and D-020 before enabling recovery writes.
- Owner: Joe
- Status: Open

### Risk R-004
- Risk: AI confidence and input behavior have not been calibrated or tested for their later milestone.
- Impact: High — an incorrect action could change family records.
- Mitigation: Keep AI writes out of M0; before later milestones, verify the 100-case calibration and confidence scoring in D-010 / D-021, both event/todo and teach-file Undo scopes in D-015 (including snapshots and LIFO restore), and the fallback criteria in D-022. Verify the PIN lockout count transitions and logs in TEST-PLAN P-003.
- Owner: Joe
- Status: Open

### Risk R-005
- Risk: REQ-006 public-ingress and Tailnet-reachability evidence was re-reviewed on 2026-11-15 and passed. The dated 2026-11-14 record includes Tailnet HTTPS success at 11:23, non-Tailnet LTE denial at 22:52, and Tailscale ON/OFF state at 11:40. Joe reports the NAS 5443 forwarding rule was deleted, not disabled; the current `router-single` screenshot shows 0 entries. Port-range forwarding and triggering tables are empty, UPnP is disabled, IPv4/IPv6 SPI firewall protection is enabled with no IPv6 Port Services entries, DDNS is disabled, and DMZ is off. The Administration page in this firmware has no Remote Management section.
- Impact: High — access could be unavailable or insufficiently restricted.
- Mitigation: REQ-006 evidence re-review passed, and REQ-007 is recorded PASS with its dated PWA-shell result and screenshot in [GATE](./GATE.md). The reported ingress was Tailscale Serve (`tailscale serve --bg http://127.0.0.1:8080`), not Caddy. Independent Review covers gate documents only and is not device UAT. App authentication is outside M0.
- Owner: Joe
- Status: Closed

### Risk R-006
- Risk: The Node Gateway, Python AI/RAG backend, local PostgreSQL/pgvector, and Ollama add service-to-service failure and resource-management boundaries.
- Impact: High — an unavailable or incorrectly routed service could interrupt requests, expose excess context, or bypass the intended closed-loop write policy.
- Mitigation: Keep services on internal networks; only the Node data-access module may hold application-runtime PostgreSQL credentials. Backup and migration are separately governed maintenance operations. Before claiming integration PASS, test health/readiness, timeout/error handling, authorized context boundaries, and fail-closed AI write behavior on JOE-SERVER.
- Owner: Joe
- Status: Open

### Risk R-007
- Risk: Public POC data or credentials become mixed with the household closed-loop environment, or real household data leaks to Cloud through copies, attachments, embeddings, model requests, logs or backups.
- Impact: High — household privacy boundary is violated.
- Mitigation: D-025 limits the POC to synthetic/test data; separate environments, datasets and credentials. Before POC use, define and test ingestion restrictions, data flows and operational safeguards; no real household data may be uploaded. Separation is a requirement, not yet verified.
- Owner: Joe
- Status: Open

### Risk R-008
- Risk: A public POC is exposed before authentication, authorization, abuse prevention and provider/service boundaries are designed and tested.
- Impact: High — unauthorized access or service abuse may occur despite using synthetic data.
- Mitigation: Design and verify POC-specific Supabase Auth, authorization, service access and abuse controls before public use; do not infer security from the provider or reuse household credentials.
- Owner: Joe
- Status: Open

### Risk R-009
- Risk: Encrypted backups cannot be recovered, contain inconsistent DB and file snapshots, or share a failure domain with the Primary.
- Impact: High — data could be permanently lost even if a backup file exists.
- Mitigation: Follow D-007 and the later isolated restore and failure tests in TEST-PLAN. Key management and age / Argon2 design remain open; the offline-copy proposal D-019 remains Draft.
- Owner: Joe
- Status: Open

### Risk R-010
- Risk: Undefined Space, smart-home and MCP boundaries, or treating Multi-Agent as already implemented, drive premature design or scope changes.
- Impact: Medium — rework or unintended M0 expansion.
- Mitigation: Keep Space and smart home TBD; decide MCP purpose, design and timing after the lesson; Multi-Agent is concept-only. Preserve REQ-001–REQ-007 unchanged.
- Owner: Joe
- Status: Open

### Risk R-011
- Risk: Authorized remote viewing could expose real household data if traffic leaves the encrypted Tailnet boundary or device caches are unencrypted or persist after access is revoked.
- Impact: High — household privacy could be violated even without Cloud storage or inference.
- Mitigation: Joe approved remote viewing only over encrypted Tailnet to authorized devices; real household data must not be sent to public Cloud, the POC, or external services. Encrypt device caches and clear them on logout or device/session revocation. Verify these controls in TEST-PLAN P-004 before enabling real-data remote access. M0 still tests only an empty app shell, so REQ-006 / REQ-007 are unchanged.
- Owner: Joe
- Status: Closed