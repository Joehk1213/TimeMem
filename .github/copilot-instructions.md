# Project Context

- TimeMem is a family-first, self-hosted life and memory system. Its core purpose is reminders plus remembering family moments, grounded in the README story of a child forgetting dictation preparation.
- The source of truth is `README.md`, `reference/PROGRESS.md`, and `reference/IMPLEMENTATION_PLAN.md`. When they conflict or leave a decision open, stop and ask; do not guess or silently resolve it.
- Phase 1 is limited to family members and family spaces, tasks, calendar reminders, photo import and organization, Memory Time Machine, and backup export plus a proposed basic restore test pending confirmation of PROGRESS item 8. Vault documents, family finance, and RAG belong outside Phase 1.
- Home Edition is the self-hosted, local-first direction. POC cloud services are experiments only, not Home Edition prerequisites. Do not claim a feature is offline until it has been verified.
- Current work status is tracked in PROGRESS.md: JOE-DESKTOP is active; JOE-SERVER is OFFLINE. Do not perform or claim SERVER validation while it is offline.
- GitHub sequence is fixed: finish and review the four foundation documents together before the first push. Do not start by syncing or pushing.

# Tech Stack - Home Edition 閉環版

- Frontend: React, TypeScript, Vite; Tailwind CSS may be used as described in README.
- Gateway: Node.js, Express, TypeScript; API, session handling, and family/member authorization belong at the backend.
- Database: PostgreSQL with ordinary relational data for Phase 1. Do not add pgvector in Phase 1.
- Photo/document files: local filesystem storage with persistent storage for self-hosted deployment. Phase 1 does not use MinIO; evaluate it later only as README describes and after review.
- Home Edition deployment target: Docker Compose for setup and upgrades; keep family data on the household's own storage by default.
- Python, FastAPI, LangGraph, and the AI Brain are deferred until the later RAG/assistant phase; do not start them for Phase 1.
- Supabase, Railway, OpenRouter, or other cloud services are POC experiments or explicitly user-enabled options, never required Home Edition dependencies.
- Do not select or promise a particular model, vector dimension, or hardware requirement before the documented target-device testing and user review.

# Monorepo Structure

The current repository is documentation-only; do not present future application directories as existing or scaffold them without approval.

```text
TimeMem/
├── .github/
│   └── copilot-instructions.md
├── reference/
│   ├── IMPLEMENTATION_PLAN.md
│   └── PROGRESS.md
└── README.md
```

- Obsidian notes live outside this repository under `C:\Project\Obsidian-Hub\TimeMem`.
- When implementation structure is approved, keep the frontend, backend gateway, and deployment configuration as distinct responsibilities, following the README stack; do not change the stack or invent additional services.
- `D:\docker-data\timemem` is available only on JOE-SERVER. It is not a desktop path and must never be added to Git.

# Key Conventions

- Scope database row-level security (RLS) by family/member and also validate authorization in the backend. UI hiding is not authorization. Do not invent child/adult or private-record policies; those remain undecided.
- Before starting work, read `reference/PROGRESS.md` and the relevant source sections in README and IMPLEMENTATION_PLAN.
- Do not skip to another STEP without review. At the end of every task, update PROGRESS.md and make the matching daily-note and `00-總覽.md` entries in Obsidian.
- Do not change the stack privately. Ask before changing technologies, adding services, or expanding Phase 1.
- Do not promise specific models or vector dimensions. Do not carry forward the legacy terms `students`, `instructors`, or `course_code`; use family/member terminology.
- Never put passwords, tokens, secret values, or `.env` contents/files into Obsidian. Do not commit credentials or secrets.
- Treat `D:\docker-data\timemem` as server-only persistent data, outside Git; never assume that drive exists on JOE-DESKTOP.
- Keep cloud data flows explicit and optional. A self-hosted deployment is not automatically secure or fully offline.
- Do not change PROGRESS.md's pending decisions unless the user explicitly asks.
