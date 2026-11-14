---
name: new-start-project-framework
description: "Use to start a new software project with the New-Start-Project-Framework V2.1 workflow: requirements, decisions, architecture, test planning, risks, M0 readiness, independent reviews, approval, daily stories, and change requests."
---

# New-Start-Project-Framework

## Purpose and Ownership

Apply this detailed workflow when Joe starts a new project with one human owner, an AI agent, and an independent third-party reviewer. It governs planning and approval; it is not permission to write product code.

- Owner and sole decision-maker / approver: Joe.
- AI agent (Luna): investigates, drafts, identifies gaps, keeps documents consistent, and runs checks. Luna must not approve decisions or M0.
- Independent third party: reviews only the six gate documents, identifies and grades issues, and does not participate in development or prescribe fixes.
- Version: V2.1 Final.

The working chain is:

`Requirements -> Decisions -> Architecture -> Test Plan -> Risks -> Dual Review -> Joe's Approval -> Development -> Daily Story -> Change Request`

## Hard Stops and Working Principles

1. **Decisions before code.** Until Joe explicitly approves M0, do not write product code, run migrations, install a database for the product, or commit product work. Planning documents and review findings are allowed.
2. **Ask short, open questions.** Do not feed the AI a proposed solution or detailed implementation recipe. Ask it to investigate and propose options; Joe judges and decides.
3. **Lock scope before design.** Define what is in and out of scope, measurable success criteria, and assumptions before choosing implementation details.
4. **Require two reviews.** Luna's consistency review and the independent review must both pass the gate.
5. **Stories are history, not authority.** A story may explain process and context, but cannot override a source-of-truth document.
6. **Keep secrets out.** Never write passwords, API keys, tokens, private keys, or `.env` values into project documents, prompts, review materials, or stories. Use variable names or placeholders only.
7. **Approval is explicit.** A passed check, cleared TBD, or review result is not Joe's approval. Never imply M0 is approved without Joe's explicit statement.
8. **Preserve history.** Do not silently rewrite an approved decision or erase a superseded proposal. Use Change Requests and retain archived material.

## Project Documents and Source of Truth

Create and maintain these project files:

1. `docs/REQUIREMENTS.md` — scope, exclusions, measurable success criteria, assumptions.
2. `docs/DECISIONS.md` — decision records, statuses, rationale, approval, and impacts.
3. `docs/ARCHITECTURE.md` — modules, boundaries, and design tied to decision IDs.
4. `docs/TEST-PLAN.md` — unit, integration, and manual UAT approach tied to requirements.
5. `docs/RISKS.md` — risks, impact, mitigation, owner, and status.
6. `docs/M0-READY.md` — M0 gate status, evidence, reviews, and Joe's approval.
7. `docs/archive/` — obsolete proposals retained as history, clearly marked obsolete.
8. The configured Obsidian story folder — one story Markdown file per calendar day.

Resolve conflicts in this order: `REQUIREMENTS.md`, `DECISIONS.md`, `ARCHITECTURE.md`, `TEST-PLAN.md`, `RISKS.md`, `M0-READY.md`, then Obsidian stories. A decision cannot silently change requirements. A scope change requires a Change Request, an updated Requirements record, and a linked new Decision.

The independent reviewer receives only the six gate documents (items 1-6). Do not provide `PROGRESS`, `TODO`, `IDEA`, `README`, old repositories, `.env`, or unrelated Vault notes.

## Roles and Prompting

- Joe makes every binding decision and is the only person who can approve M0.
- Luna may inspect authorized project materials, list TBDs, draft records, check cross-document consistency, and propose ways to close findings. Luna must label proposals as drafts until Joe decides.
- The independent reviewer checks for contradictions, infeasible requirements, missing coverage, incomplete operations, and risks. The reviewer reports findings and severity without providing solutions.
- Keep prompts focused on the next unresolved question. Do not have the agent turn an unapproved proposal into a binding decision.

## Workflow

### Phase 0 — Establish the project

1. Initialize the project repository and `docs/`; create the configured Obsidian story folder if Joe has supplied its location.
2. Do not inspect or alter unrelated Vault notes, old repositories, or real `.env` files.
3. Establish or adapt the `obsidian-story-record` and `project-start-workflow` skills for the project. Run the workflow through the skills where available.
4. Create the six gate documents in draft/review states. Do not create product code, migrations, or a product database.
5. Record the current phase and unresolved items in the project’s existing tracking convention, if one exists. Do not treat tracking notes as authority over the six gate documents.

### Phase 1 — Lock requirements and assumptions

Draft `docs/REQUIREMENTS.md` with:

```markdown
# Requirements

## In Scope
- ...

## Out of Scope
- ...

## M0 Success Criteria
- [measurable number] [observable action/result] [threshold]

## Assumptions
- [assumption]
```

Success criteria must be measurable and state numbers plus an observable action or result. Do not use subjective adjectives such as “easy,” “fast,” “accurate,” or “good enough” as acceptance criteria. If a criterion cannot yet be quantified, leave it unresolved; do not smuggle it into the requirements as a vague promise.

Assumptions are explicit and reviewable. If one proves false, treat changing it as a Change Request and update the requirements through the same controlled path as a scope change. Lock the requirements before discussing how to implement them.

### Phase 2 — Resolve TBDs and record decisions

1. Review only authorized legacy materials that Joe has identified. List unresolved choices as TBDs; do not infer approval from existing code or old proposals.
2. Ask Joe about each decision in focused prompts. Record it only after Joe decides.
3. Give every decision a stable `D-001`-style ID. Never reuse an ID.
4. Include every field in each record:

```markdown
### D-001
- Status: Draft
- Date: YYYY-MM-DD
- Decision: ...
- Rationale: ...
- Approver: Joe / Pending
- Supersedes: None / D-xxx
- Superseded By: None / D-xxx
- Architecture Impact: ...
- CR: None / CR-xxx
```

Allowed Decision statuses are exactly `Draft`, `Approved`, `Superseded`, and `Rejected`. Mark a decision `Approved` only after Joe approves it. When a new decision replaces an old one, mark the old record `Superseded` and set `Superseded By`; preserve the old text and link both records. Move unused proposals to `docs/archive/`, label them obsolete, and retain them.

### Phase 3 — Architecture, risks, and verification plan

Create `docs/ARCHITECTURE.md` only from approved decisions. Describe modules, ownership and boundaries, data access, and security-relevant design boundaries. Every choice that follows a decision includes an explicit reference, for example `Database: [choice] — Reference: D-001`. If a needed decision is not approved, mark the design point TBD rather than presenting it as settled.

Create `docs/RISKS.md` with one record per risk:

```markdown
### Risk R-001
- Risk: ...
- Impact: High
- Mitigation: ...
- Owner: Joe
- Status: Open
```

Allowed Risk statuses are exactly `Open`, `Monitoring`, `Mitigated`, `Accepted`, and `Closed`. State impact and mitigation plainly; a risk is not closed merely because it has an owner.

Create `docs/TEST-PLAN.md` with:

- Unit tests: what requirement or behavior each verifies.
- Integration tests: which component boundaries and flows each verifies.
- Manual UAT: steps and observable outcomes for Joe or the intended user.
- Acceptance Criteria: trace directly to `REQUIREMENTS.md`; do not invent additional product acceptance thresholds here.

Identify missing test coverage as TBD or a review finding; do not claim coverage that has not been specified.

### Phase 4 — Daily story record

After a confirmed decision or meaningful project progress, use the `obsidian-story-record` workflow:

1. Use the configured Obsidian story folder only. If its location is unknown, ask Joe; never search or modify unrelated Vault notes.
2. Use exactly one Markdown story file per calendar day. Find and update today's file on every run; create a new file only if none exists for today.
3. Write a clear, natural narrative with the date, what happened or was decided, how the process went, the outcome, and the next step. There is no word limit; the title is up to Luna.
4. Add or update only today's story file. Never overwrite other notes, write secrets, or describe M0 as approved without Joe's explicit approval.
5. Treat the story as historical context only. If it conflicts with a gate document, the gate document wins.

### Phase 5 — Dual review and M0 exit gate

**Review 1 — Luna consistency review**

- Compare `REQUIREMENTS.md`, `DECISIONS.md`, `ARCHITECTURE.md`, `TEST-PLAN.md`, `RISKS.md`, and `M0-READY.md`.
- Report contradictions, missing references, untestable criteria, uncovered risks, and incomplete gate evidence.
- Do not silently edit the reviewed documents or approve M0. Propose findings separately for Joe to decide.

**Review 2 — independent third-party review**

- Give the reviewer only those same six gate documents.
- Ask for findings with a severity, affected document/section, and concise evidence. Do not ask for solutions.
- Classify findings as:
  - **Critical** — makes the project unworkable, risks data loss/destruction, or has an incorrect permission boundary.
  - **Major** — contradictions, incomplete workflow or operations, insufficient testing, inadequate logging or monitoring, unclear errors, or other substantive gaps.
  - **Minor** — only wording, formatting, naming, or layout.
- Do not downgrade test gaps, logging, error-message clarity, monitoring, or incomplete operations to Minor.

**M0 exit condition:** Critical findings = 0 and Major findings = 0. Minor findings may remain if recorded. If either review finds a Critical or Major issue, return it to Luna to investigate and draft a correction for Joe; do not let the reviewer prescribe the fix. Update the relevant source-of-truth documents, then repeat both reviews. Preserve findings and review outcomes in the gate record or an established review log.

### Phase 6 — Controlled Change Requests

After requirements or an approved decision need to change:

1. Do not silently edit the approved statement or reuse an existing ID.
2. Create a unique `CR-001`-style ID. Record the request, reason, Joe's approval status, affected requirements/decisions, and resulting decision ID.
3. Wait for Joe's approval before applying a proposed change.
4. If scope changes, update `REQUIREMENTS.md` and create a linked new Decision; record both sides of the change.
5. Mark replaced decisions `Superseded` and link the replacement. Keep the prior decision and change history.
6. Re-run both Phase 5 reviews. Any requirements change invalidates a prior M0 approval; set M0 to `Expired` until re-reviewed and explicitly re-approved by Joe.

```markdown
### CR-001
- Status: Draft
- Content: ...
- Reason: ...
- Approver: Joe / Pending
- Affected Requirements: ...
- Resulting Decision: D-xxx / Pending
```

```markdown
### D-xxx
- Status: Draft
- Date: YYYY-MM-DD
- Decision: ...
- Rationale: ...
- Approver: Joe / Pending
- Supersedes: D-xxx / None
- Superseded By: None
- Architecture Impact: ...
- CR: CR-001
```

### Phase 7 — Joe's final M0 approval

Create and maintain `docs/M0-READY.md` with:

```markdown
# M0 Ready

- Status: Draft
- M0 Goal: ...
- Acceptance Items: ...
- Requirements Reference: ...
- Decision / Architecture / Test / Risk Evidence: ...
- Luna Review: Pending
- Independent Review: Pending
- Critical Findings: ...
- Major Findings: ...
- Minor Findings: ...
- Approved By: Pending
- Approved Date: Pending
- GitHub Branch Protection: Not enabled; do this as the first DEVELOP step.
```

Allowed M0 statuses are exactly `Draft`, `In Review`, `Approved`, and `Expired`.

Move to `In Review` when the gate documents are ready for both reviews. Move to `Approved` only after Joe explicitly approves and both reviews have zero Critical and zero Major findings. Record `Approved By: Joe` and the actual approval date. Luna may prepare the record but may not grant approval. If approved requirements later change, mark M0 `Expired` and repeat review and approval.

Do not enable Branch Protection during M0 planning. It is the first step of DEVELOP, before product code, migrations, or database setup.

### Phase 8 — Develop only after approval

1. Confirm `M0-READY.md` is `Approved`, approval is explicitly Joe's, and the approval has not expired.
2. As the first DEVELOP action, enable GitHub Branch Protection. Record its state. Only then begin product implementation.
3. Keep implementation out of scope changes. A feature idea returns to Phase 1 for an explicit In Scope / Out of Scope decision.
4. If an assumption fails or a decision changes, use Phase 6 and repeat both reviews and approval as required.
5. Apply the same gate workflow to later milestones without assuming they are approved by M0.

## Gate Record Status and Review Checklist

Before reporting M0 ready for Joe, verify:

- All six gate files exist and agree with the source-of-truth order.
- Requirements have explicit In Scope, Out of Scope, measurable M0 Success Criteria, and Assumptions.
- Every decision has a unique ID, allowed status, approver state, and required links/impact fields.
- Architecture choices trace to approved decision IDs.
- Test coverage traces to requirements without adding acceptance thresholds.
- Risks have impact, mitigation, owner, and an allowed status.
- Both reviews cover all six documents; the independent reviewer received no unrelated material.
- Critical = 0 and Major = 0. Minor findings, if any, are limited to wording, formatting, naming, or layout and are recorded.
- M0 approval remains pending until Joe explicitly approves.
- No secrets were included in project or story files.

Report the current phase, unresolved TBDs/findings, document updates, and next decision needed. Never present a blocked or pending gate as passed.

## Future Upgrade Observations

These are intentional future-evolution notes, **not vulnerabilities or current gate failures**:

1. **Decision ADR split:** once decision records pass `D-200`, the project may split `DECISIONS.md` into individual files such as `docs/decisions/D-001.md`. Preserve IDs, statuses, cross-references, and history during migration.
2. **Additional milestone gates:** M1 and M2 gates may be added later. Keep gate records and checklists milestone-scoped so the same framework can add those gates without replacing the M0 workflow or redesigning the framework.
