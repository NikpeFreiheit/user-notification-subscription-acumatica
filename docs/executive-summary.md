# Executive Summary

## Problem statement

Acumatica users need to stay aware of relevant changes to business records — for example escalated Cases or newly created Appointments — without manually monitoring the system. Acumatica's native Business Events provide admin-configured, backend automation, but there is no user-facing way for an individual user to subscribe to the changes they personally care about, define the conditions, choose the notification text, and pick how they are notified. This document specifies a self-service Subscription Service that fills that gap. Both users and administrators can manage subscriptions.

## Solution overview

The Subscription Service is an event-driven layer on top of Acumatica. It consumes entity-change events from Acumatica Business Events via RabbitMQ, matches each event against users' subscriptions, renders a notification from a selected template, and delivers it through the chosen channel(s). It reuses Business Events as the event source rather than re-implementing change detection.

Key properties:
- Self-service: a non-technical user configures a subscription through the UI — entity, event type, filter conditions, channels, template — without writing queries.
- Generic by design: one subscription model serves any entity type, and conditions are generic `{field, operator, value}` rules. The MVP implements two entities; adding more is a configuration change, not entity-specific code.
- Reuses ERP identity: authentication via Acumatica SSO; role-based authorization (User vs Administrator).
- Reliable: guaranteed delivery via acknowledge-after-processing, retry, and a dead-letter queue.

## Key assumptions

- Deployment: mid-market Acumatica instance, 50–500 users; up to ~3,000 active subscriptions (conservative ceiling).
- MVP entities: Case (Created, Updated) and Appointment (Created) — the examples named in the assignment.
- Channels: Email and SMS; the user chooses per subscription.
- Filter logic: `AND` only in MVP; `OR` / `NOT` deferred to Phase 2.
- Templates: admin-owned, may contain variables; users select a template and may add optional plain custom text.
- Language: English only in MVP.
- Authentication: reuse Acumatica SSO; no separate credential store.
- Event source: Business Events emit entity-change events carrying the changed field values (to confirm — see Open Questions).

## Scope boundary

MVP delivers core self-service subscriptions for two entities over Email/SMS, with `AND` filters and guaranteed delivery. `OR` / `NOT` logic, transition semantics, `Deleted` events, additional entities and channels, and analytics are Phase 2 / Future (see Implementation Roadmap).