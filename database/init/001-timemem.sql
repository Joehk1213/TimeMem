CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS schema_migrations (
  version text PRIMARY KEY,
  applied_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS families (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  display_name text NOT NULL,
  role text NOT NULL CHECK (role IN ('owner', 'adult', 'child')),
  pin_hash text,
  failed_pin_attempts integer NOT NULL DEFAULT 0 CHECK (failed_pin_attempts >= 0),
  locked_until timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  UNIQUE (family_id, display_name)
);

CREATE TABLE IF NOT EXISTS app_sessions (
  token_hash text PRIMARY KEY,
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  expires_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  revoked_at timestamptz
);

CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  created_by uuid NOT NULL REFERENCES members(id),
  title text NOT NULL,
  description text NOT NULL DEFAULT '',
  starts_at timestamptz,
  ends_at timestamptz,
  visibility text NOT NULL DEFAULT 'shared' CHECK (visibility IN ('shared', 'private')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  CHECK (ends_at IS NULL OR starts_at IS NULL OR ends_at >= starts_at)
);

CREATE TABLE IF NOT EXISTS todos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  created_by uuid NOT NULL REFERENCES members(id),
  title text NOT NULL,
  details text NOT NULL DEFAULT '',
  due_at timestamptz,
  completed_at timestamptz,
  visibility text NOT NULL DEFAULT 'shared' CHECK (visibility IN ('shared', 'private')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS event_changes (
  id bigserial PRIMARY KEY,
  entity_type text NOT NULL CHECK (entity_type IN ('event', 'todo')),
  entity_id uuid NOT NULL,
  actor_id uuid NOT NULL REFERENCES members(id),
  previous_value jsonb NOT NULL,
  changed_value jsonb NOT NULL,
  changed_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS inputs (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES members(id),
  content text NOT NULL,
  analysis jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS photos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  created_by uuid NOT NULL REFERENCES members(id),
  sha256 char(64) NOT NULL,
  storage_path text NOT NULL,
  captured_at timestamptz,
  metadata jsonb NOT NULL DEFAULT '{}',
  created_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz,
  UNIQUE (family_id, sha256)
);

CREATE TABLE IF NOT EXISTS memories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  created_by uuid NOT NULL REFERENCES members(id),
  title text NOT NULL,
  story text NOT NULL DEFAULT '',
  visibility text NOT NULL DEFAULT 'shared' CHECK (visibility IN ('shared', 'private')),
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  deleted_at timestamptz
);

CREATE TABLE IF NOT EXISTS memory_members (
  memory_id uuid NOT NULL REFERENCES memories(id) ON DELETE CASCADE,
  member_id uuid NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  PRIMARY KEY (memory_id, member_id)
);

CREATE TABLE IF NOT EXISTS memory_photos (
  memory_id uuid NOT NULL REFERENCES memories(id) ON DELETE CASCADE,
  photo_id uuid NOT NULL REFERENCES photos(id) ON DELETE CASCADE,
  position integer NOT NULL DEFAULT 0,
  PRIMARY KEY (memory_id, photo_id)
);

CREATE TABLE IF NOT EXISTS embeddings (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  family_id uuid NOT NULL REFERENCES families(id) ON DELETE CASCADE,
  entity_type text NOT NULL,
  entity_id uuid NOT NULL,
  embedding vector(1024) NOT NULL,
  content_hash char(64) NOT NULL,
  model text NOT NULL DEFAULT 'bge-m3',
  created_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (entity_type, entity_id, content_hash)
);

CREATE INDEX IF NOT EXISTS events_family_time_idx ON events (family_id, starts_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS todos_family_due_idx ON todos (family_id, due_at) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS memories_family_idx ON memories (family_id) WHERE deleted_at IS NULL;
CREATE INDEX IF NOT EXISTS embeddings_family_model_idx ON embeddings (family_id, model);
CREATE INDEX IF NOT EXISTS embeddings_cosine_idx ON embeddings USING hnsw (embedding vector_cosine_ops);

INSERT INTO schema_migrations(version) VALUES ('001-timemem-hybrid5')
ON CONFLICT (version) DO NOTHING;
