# Functional Requirements

## Scope and conventions

- MVP entities: Case, Appointment.
- MVP channels: Email, SMS.
- MVP filter logic: `AND` only. `OR` / `NOT` are Phase 2.
- Filter matching uses **state** semantics (condition evaluated against the resulting field value of the event). Transition semantics are Phase 2.
- Priority: **MUST** = required for MVP; **SHOULD** = expected in MVP but degradable; **Phase 2** = explicitly out of MVP.
- Roles: **User** (manages own subscriptions), **Administrator** (manages all subscriptions and templates).
- Filter condition model and per-entity fields/operators: see [filter-conditions.md](/docs/filter-conditions.md).

---

## 1. Authentication and access

| ID | Priority | Requirement |
|---|---|---|
| FR-001 | MUST | The system authenticates users through the existing Acumatica ERP session (SSO). The Subscription Service does not maintain its own credentials. |
| FR-002 | MUST | The system authorizes actions by role. A User can act only on their own subscriptions; an Administrator can act on all subscriptions and on templates. |

Acceptance criteria:
- [ ] An unauthenticated request to the management UI/API is rejected.
- [ ] A User cannot read, edit, or delete a subscription owned by another user.
- [ ] An Administrator can read and edit any subscription and any template.
- [ ] Role is resolved from the ERP, not stored or self-declared by the Subscription Service.

---

## 2. Subscription management

| ID | Priority | Requirement |
|---|---|---|
| FR-010 | MUST | A User can create a subscription scoped to themselves. |
| FR-011 | MUST | A User can view a list of their own subscriptions. |
| FR-012 | MUST | A User can edit the parameters of their own subscription. |
| FR-013 | MUST | A User can enable or disable their own subscription without deleting it. |
| FR-014 | MUST | A User can delete their own subscription. |
| FR-015 | MUST | An Administrator can view, edit, enable/disable, and delete any subscription in the system. |

Acceptance criteria:
- [ ] A created subscription is persisted and appears in the owner's list.
- [ ] A disabled subscription is retained but produces no notifications until re-enabled.
- [ ] Editing a subscription takes effect for events occurring after the change is saved.
- [ ] A deleted subscription produces no further notifications.

---

## 3. Subscription configuration

| ID | Priority | Requirement |
|---|---|---|
| FR-020 | MUST | A subscription specifies one entity type and one or more event types in scope: Case (`Created`, `Updated`), Appointment (`Created`). |
| FR-021 | MUST | A subscription specifies zero or more filter conditions in the `{field, operator, value}` model, combined with `AND`. |
| FR-022 | MUST | A subscription specifies one or more delivery channels (Email and/or SMS); the choice is the user's. |
| FR-023 | MUST | A subscription specifies a notification template and may add an optional plain-text custom subject or note. Custom text does not support variable substitution. |
| FR-024 | Phase 2 | A subscription may combine conditions with `OR`/`NOT`. Out of MVP. |

Acceptance criteria:
- [ ] Only fields valid for the selected entity can be used as conditions (per [filter-conditions.md](/docs/filter-conditions.md)).
- [ ] Only operators valid for a field's type are accepted.
- [ ] A subscription with no template selected cannot be saved.
- [ ] At least one channel must be selected to save a subscription.

---

## 4. Notification templates

| ID | Priority | Requirement |
|---|---|---|
| FR-030 | MUST | An Administrator can create, edit, and disable notification templates. |
| FR-031 | MUST | A template may contain variables that are substituted from the triggering event's data at render time (see [template-variables.md](/docs/template-variables.md)). |
| FR-032 | MUST | A User can select from available templates but cannot create or edit templates. |

Acceptance criteria:
- [ ] A template created by an Administrator becomes selectable by Users.
- [ ] A disabled template is not offered for new subscriptions; existing subscriptions referencing it are handled per a defined fallback (to confirm — Open Questions).
- [ ] At render time, supported variables are replaced with event values; unknown variables are handled per a defined rule (to confirm — Open Questions).

---

## 5. Event processing and delivery

| ID | Priority | Requirement |
|---|---|---|
| FR-040 | MUST | The system consumes entity-change events emitted by Acumatica Business Events, transported via the message queue (RabbitMQ). |
| FR-041 | MUST | For each event, the system selects active subscriptions matching the entity type and event type, and evaluates their filter conditions against the event data. |
| FR-042 | MUST | For each matched subscription, the system renders a notification from the selected template and event data. |
| FR-043 | MUST | The system delivers each rendered notification through the subscription's selected channel(s) via the Delivery Service. |
| FR-044 | MUST | Delivery is guaranteed: an event is acknowledged only after successful processing; failed processing is retried, and after N attempts the message is routed to a dead-letter queue. |

Acceptance criteria:
- [ ] One event matching N subscriptions produces N notifications.
- [ ] A subscription whose conditions do not match the event produces no notification.
- [ ] If delivery/processing fails, the event is not acknowledged and is retried.
- [ ] After the configured retry limit, the event is moved to the DLQ and not silently dropped.

---

## 6. Notification history

| ID | Priority | Requirement |
|---|---|---|
| FR-050 | MUST | The system records each notification attempt with subscription reference, channel, status, and timestamp. |
| FR-051 | SHOULD | A User can view the history of notifications generated by their own subscriptions. |
| FR-052 | MUST | An Administrator can view the history of all notifications. |

Acceptance criteria:
- [ ] Each delivery attempt has a status (e.g., delivered / failed) and a timestamp.
- [ ] A User sees only their own notification history.
- [ ] History entries reference the originating subscription.

---

## 7. Channel contact details

| ID | Priority | Requirement |
|---|---|---|
| FR-060 | MUST | The system resolves the recipient's email and phone for the selected channels. |
| FR-061 | SHOULD | The User can view which contact details will be used for each channel. |

Acceptance criteria:
- [ ] An Email subscription has a resolvable email address before it can deliver.
- [ ] An SMS subscription has a resolvable phone number before it can deliver.
- [ ] Source of contact details (ERP profile vs. user-entered) is defined (to confirm — Open Questions).