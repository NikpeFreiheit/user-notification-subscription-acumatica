# Implementation Roadmap

## MVP (Must-have)

- Subscription CRUD for users, scoped to themselves (FR-010..014).
- Administrator management of all subscriptions and templates (FR-015, FR-030..032).
- Entities: Case, Appointment.
- Event types: Created, Updated (Case); Created (Appointment).
- Filter conditions in the `{field, operator, value}` model, combined with `AND`.
- Channels: Email, SMS.
- Template selection plus optional plain custom note.
- Event-driven delivery via Business Events → RabbitMQ → Event Processor → Delivery Service.
- Guaranteed delivery: ack-after-processing, retry, dead-letter queue (FR-044).
- Notification history with status and timestamp (FR-050..052).
- Authentication via ERP SSO; role-based authorization.

**MVP success criteria**
- A user can self-serve a subscription and receive a matching notification through the chosen channel(s).
- A subscription whose conditions do not match produces no notification.
- No event is lost: failures are retried and surfaced via the DLQ.
- An Administrator can view and manage all subscriptions and templates.

## Phase 2 (Should-have)

- `OR` / `NOT` filter logic.
- Transition semantics (field *changed to* value), in addition to state.
- `Deleted` events; additional entity types and filterable fields (configuration-driven).
- Richer template management (e.g. user-level template variations).
- Bulk operations on subscriptions.
- Quiet hours / frequency limits.
- Additional channels (push, messenger).

## Future (Could-have)

- Notification analytics and dashboards.
- Time-based / scheduled triggers.
- Team / shared subscriptions.
- Digest (batched) notifications.
