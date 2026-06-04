-- Conceptual PostgreSQL schema — User Notification Subscription (MVP)
-- Scope: Case + Appointment entities; Email + SMS channels; AND filter logic.
-- Identity is owned by Acumatica ERP: this schema holds no users table and no credentials.
-- Out of MVP (not modelled here): OR/NOT logic, transition semantics, deleted events, audit logging, additional entities/channels.

-- Admin-owned notification templates (FR-030, FR-031)
CREATE TABLE template (
    id          BIGSERIAL PRIMARY KEY,
    name        TEXT NOT NULL,
    subject     TEXT NOT NULL,
    body        TEXT NOT NULL,                       -- may contain variables, substituted at render time
    status      TEXT NOT NULL DEFAULT 'active'       -- active | disabled
                CHECK (status IN ('active', 'disabled')),
    created_by  TEXT NOT NULL,                       -- ERP user id of the admin (external reference)
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- A user's subscription (FR-010..015, FR-020..023)
-- Filter conditions are combined with AND in MVP. OR/NOT and an explicit
-- match_logic column are Phase 2; omitted here to avoid a single-valued column.
CREATE TABLE subscription (
    id            BIGSERIAL PRIMARY KEY,
    owner_user_id TEXT NOT NULL,                     -- ERP user id; scopes ownership (FR-002), external reference
    entity_type   TEXT NOT NULL                      -- Case | Appointment (MVP)
                  CHECK (entity_type IN ('Case', 'Appointment')),
    template_id   BIGINT NOT NULL REFERENCES template(id),
    custom_note   TEXT,                              -- optional plain text, no variable substitution (FR-023)
    status        TEXT NOT NULL DEFAULT 'active'     -- active | disabled (FR-013)
                  CHECK (status IN ('active', 'disabled')),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- Event types that trigger a subscription (FR-020). Created | Updated (MVP); Deleted = Phase 2.
-- Enforced in application (not expressible as a simple CHECK here):
--   * at least one event type per subscription;
--   * entity-specific scope: Appointment allows only 'Created'; 'Updated' is valid for Case only
--     (see FR-020 / project-summary scope).
CREATE TABLE subscription_event_type (
    subscription_id BIGINT NOT NULL REFERENCES subscription(id) ON DELETE CASCADE,
    event_type      TEXT NOT NULL
                    CHECK (event_type IN ('Created', 'Updated')),
    PRIMARY KEY (subscription_id, event_type)
);

-- Delivery channels for a subscription (FR-022).
-- Enforced in application: at least one channel per subscription (cannot be expressed as a CHECK here).
CREATE TABLE subscription_channel (
    subscription_id BIGINT NOT NULL REFERENCES subscription(id) ON DELETE CASCADE,
    channel         TEXT NOT NULL
                    CHECK (channel IN ('Email', 'SMS')),
    PRIMARY KEY (subscription_id, channel)
);

-- Filter conditions {field, operator, value} (FR-021, filter-conditions.md). Combined with AND.
CREATE TABLE subscription_condition (
    id              BIGSERIAL PRIMARY KEY,
    subscription_id BIGINT NOT NULL REFERENCES subscription(id) ON DELETE CASCADE,
    field           TEXT NOT NULL,                   -- e.g. Status, Priority, Assigned To, Scheduled Date
    operator        TEXT NOT NULL,                   -- =, before, after, between, contains ... per field type
    value           TEXT NOT NULL,                   -- compared value; 'me' resolves to owner_user_id at match time
    value_to        TEXT                             -- upper bound, used only for range operators (between)
);

-- Per-user contact addresses, one row per channel (FR-060, FR-061).
-- user_id is an external ERP reference (no local users table).
CREATE TABLE user_contacts (
    user_id  TEXT NOT NULL,                          -- ERP user id (external reference)
    channel  TEXT NOT NULL
             CHECK (channel IN ('Email', 'SMS')),
    address  TEXT NOT NULL,                          -- email address or phone number for this channel
    PRIMARY KEY (user_id, channel)
);

-- Sent-notification history (FR-050..052)
CREATE TABLE notification (
    id              BIGSERIAL PRIMARY KEY,
    subscription_id BIGINT NOT NULL REFERENCES subscription(id),
    channel         TEXT NOT NULL
                    CHECK (channel IN ('Email', 'SMS')),
    recipient       TEXT NOT NULL,                   -- resolved email/phone at send time
    status          TEXT NOT NULL                    -- delivered | failed
                    CHECK (status IN ('delivered', 'failed')),
    error_detail    TEXT,                            -- populated when status = failed
    source_event_id TEXT,                            -- reference to the triggering event, if available
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()   -- send timestamp
);

-- Supports the matcher candidate lookup: load active subscriptions for an entity type (FR-041)
CREATE INDEX idx_subscription_entity_active ON subscription (entity_type, status);