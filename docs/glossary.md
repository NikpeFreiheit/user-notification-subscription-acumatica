# Glossary

## Project context

**Subscription Service** — The application specified by this document. It consumes entity-change events from Acumatica Business Events via RabbitMQ, matches each event against users' subscription parameters, renders notification messages, and hands them to the Delivery Service. It adds a user-facing, self-service subscription layer on top of Acumatica; it does not detect entity changes itself.

**Acumatica Business Events** — Acumatica's native event-driven automation mechanism: it detects data changes, user actions, or configured conditions and triggers pre-configured actions. In this design it is the event source that the Subscription Service consumes; the Subscription Service does not build its own change detection.

**Event-driven via RabbitMQ** — Architectural approach using the RabbitMQ message broker for asynchronous communication between the event source (Business Events output, published by the Adapter) and the consuming components (Event Consumer, Subscription Matcher, Notification Renderer, Notification Dispatcher).

**Adapter** — Component that receives entity-change events from Acumatica Business Events and publishes them to RabbitMQ.

**Event Consumer** — Component that consumes events from RabbitMQ and passes them into processing; acknowledges an event only after it has been processed successfully.

**Subscription Matcher** — Component that, for a received event, loads candidate subscriptions and evaluates their filter conditions against the event data to determine which subscriptions match.

**Notification Renderer** — Component that builds the notification message for a matched subscription by substituting template variables with event data.

**Notification Dispatcher** — Component that hands rendered notifications to the Delivery Service for the subscription's selected channel(s).

**Delivery Service** — External component that delivers notifications to recipients through channel gateways (Email, SMS).

## Filter and subscription context

**Entity type** — The business object a subscription targets. MVP: Case, Appointment.

**Event type** — The kind of change to an entity: Created, Updated, Deleted. A separate subscription dimension, not a filter condition. MVP: Created and Updated (Case), Created (Appointment); Deleted is Phase 2.

**Field** — An attribute of an entity that can be used in a filter condition (e.g. Status, Priority, Assigned To, Scheduled Date).

**Filter condition** — A predicate on an entity field, expressed as `{field, operator, value}` (e.g. `Status = Escalated`). A subscription's conditions are combined with `AND` in MVP. Filter conditions decide whether a notification is sent.

**Channel** — A delivery method for a notification: Email or SMS. A subscription attribute (how to deliver), not a filter condition.

**Subscription** — The central object: `entity_type` + one or more event types + filter conditions + channel(s) + a template (+ optional custom note). Owned by a user and matched against events to produce notifications.

**Notification Template** — A reusable, admin-owned message template. May contain variables that are substituted from event data at render time.

**Custom plain-text (subject / note)** — Optional plain text a user adds to a subscription in addition to the selected template. Does not support variable substitution. ("Custom plain-text" and "subject / note" refer to the same optional field.)

**Notification** — A message generated for a matched subscription and delivered (or attempted) through a channel. Recorded in history with status and timestamp.