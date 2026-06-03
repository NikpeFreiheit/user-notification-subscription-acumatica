# Project Summary
| Date | Version |
| --- | --- |
| 04 june 2026 | 0.1 |

| Project Topic | Development of a solution for creating a service for subscribing to notifications about entity changes |
| --- | --- |
| System Type | Subscription Service |
| Stakeholder | Acumatica |
| Prepared by | Veronika Gvozdeva, System Analyst |


## Scope assumptions

### In scope
Requirements definition for a Subscription Service application that consumes entity change events from the existing Acumatica Business Events mechanism via RabbitMQ, matches incoming events against user subscription parameters, generates notification messages, and forwards them to the Delivery Service.

Users can select a notification template and optionally provide a custom plain-text subject or note. Custom text does not support variable substitution.

Requirements definition for a user-facing self-service UI of the Subscription Service that allows users to create and manage subscriptions and customize notification text.

The scope is limited to the scenarios explicitly mentioned in the assignment:

**"Case" entity:** 
- Event types are "Created", "Updated"
- Fields are "Priority", "Status", "Assigned to"
- Condition for "Priority" is "High"
- Condition for "Status" is "Escalated"
- Conditions for "Assigned to" is a placeholder value based on the authenticated user's User_id. A user can only access the User_id value associated with their account.
- Channels are Email and/or SMS - the choice is up to the user

**"Appointment" entity**: 
- Event type is "Created"
- Fields are "Created date", "Scheduled date", "Assigned to"
- The condition for Created date / Scheduled date is a from–to range
- Conditions for "Assigned to" is a placeholder value based on the authenticated user's User_id. A user can only access the User_id value associated with their account.
- Channels are Email and/or SMS - the choice is up to the user

#### Data flow
For the purpose of this assignment, it is assumed that Acumatica Business Events already exist and serve as the event source for the Subscription Service.

### Out of scope
The MVP does not define requirements for administrator-oriented backend automation, as this functionality is already provided by Acumatica Business Events.

The MVP does not cover subscriptions for the following entity changes:

**Case entity:** 
- Event type is "Deleted"
- Fields are "Priority", "Status",
- Conditions for "Priority" are "Low", "Normal"
- "Status" conditions other than "Escalated"

**Appointment entity**: 
- Event types are "Updated", "Deleted"

The MVP does not cover time-based triggers as 
- Pre-event reminders (notifications sent before a scheduled date or event)
- On-date notifications (notifications triggered when a specified date or event occurs)
- Overdue event notifications (notifications for missed deadlines or overdue records)
- Escalation notifications (notifications triggered when an item remains unprocessed or unchanged for a defined period)
- Recurring notifications (daily, weekly, monthly, or custom scheduled notifications)
- Record age-based notifications (notifications triggered based on the age of a record since its creation date)

## Solution Options

|Architecture concept| Implementation effort| Reliability (guaranteed delivery) | Coupling to source schema | Fit with existing Acumatica architecture |
| --- | --- | --- | --- | --- |
| Event-driven via RMQ | No new event source required (reuses Business Events). Added effort: operating a message broker plus building the matching/subscription layer and a Business Events → RMQ adapter. | Durable delivery (queue + retry/DLQ). | Coupled to event contract, but decoupled from physical database schema. | Aligns with existing event-driven model in Acumatica Business Events, enabling reuse of current event infrastructure. |
| CDC | Requires DB-level integration, schema mapping, change log processing, and handling of schema evolution. Additional effort for ensuring consistency of business-level events vs raw DB changes. | Depends on CDC tooling and log processing reliability. | Strong coupling to source schema. Renaming or restructuring tables/fields may break downstream consumers or require remapping logic. | Introduces a parallel event source alongside the existing Business Events mechanism. |
| Webhook (sync) | Requires implementation of HTTP endpoints, request handling, retry mechanism, authentication, and idempotency support | Depends on retry logic and availability of downstream services; no built-in event persistence | Payload structure is defined contractually and may break on changes to event structure | Can be used for external integrations but does not naturally align with event-driven internal mechanisms |
| Polling | Requires only scheduled jobs and data querying logic without external-facing interfaces | Changes may be missed between polling intervals; reliability depends on polling frequency and system load | Tightly coupled to database or query structure; schema changes directly affect polling logic | Introduces periodic load and does not align with event-driven architecture already present in Acumatica |

## Solution Selection

### Event-driven via RabbitMQ
Event-driven via RMQ was selected due to its durable delivery capabilities, decoupling from the source database schema, and compatibility with the existing Acumatica Business Events approach. 

## Assumptions context

### Rationale for Selected Entities
The Case and Appointment entities were selected for the MVP based on the examples provided in the assignment. These entities also allow demonstration of different filter condition types, including picklist-based and date/time-based filtering.

### Subscription Scenarios Included for Demonstration of the Generic Approach

|Subscription Business Context | Subscription parameters|
| --- | --- |
| Monitor priority changes within the Case entity | Entity type **AND** Channel **AND** Event type **AND** Field is "Priority" **AND** Filter condition is "High" |
| Monitor assignment of an entity to a user |Entity type **AND** Channel **AND** Event type **AND** Field is "Assigned to" **AND** Filter condition=user_id |
| Monitor status changes within the Case entity| Entity type **AND** Channel **AND** Event type **AND** Field is "Status" **AND** Filter condition ("Escalated")|
| Monitor creation of a new appointment |Entity type **AND** Channel **AND** Event type **AND** Created date or Scheduled date between "from — to" |

### Subscription Configuration Selected for MVP

|User role | Filter parameters for subscription|
| --- | --- |
| Manager/Dispatcher | 1. Entity type is "Case" **AND** Channel are email and/or SMS **AND** Event type is "Updated" **AND** Field is "Priority" **AND** Condition is "High"<br> <br>2. Entity type is "Case" **AND** Channel are email and/or SMS **AND** Event type is "Created" **AND** Field is "Priority" **AND** Condition is "High"<br> <br>3. Entity type is "Case" **AND** Channel are email and/or SMS **AND** Event type is "Updated" **AND** Field is "Status" **AND** Condition is "Escalated" <br><br> 4. Entity type is "Appointment" **AND** Channel are email and/or SMS **AND** Event type is "Created" **AND** Scheduled date between "from — to" |
| Agent/Technician | 1. Entity type is "Case" **AND** Channel are email and/or SMS **AND** Event type is "Created" **AND** Field is "Assigned to" **AND** Filter condition=user_id <br> <br>2. Entity type is "Appointment" **AND** Channel are email and/or SMS **AND** Event type is "Created" **AND** Scheduled date between "from — to" **AND** Field is "Assigned to" **AND** Filter condition=user_id |

### Subscription Service Users
The service is intended for internal users authenticated within the ERP environment of an Acumatica customer organization.

To receive notifications, a user must configure at least one notification channel:
 - Email address
 - Phone number for SMS notifications

### Channels
Email and/or SMS - the choice is up to the user
### Auth
Reusing ERP authentication
### Language
English

## Event load
For the MVP, the solution is designed based on the following assumptions for a single Acumatica customer instance:

 - Up to 500 ERP users
 - Up to 3,000 active notification subscriptions

These assumptions are used to define the expected load and solution boundaries for the MVP.