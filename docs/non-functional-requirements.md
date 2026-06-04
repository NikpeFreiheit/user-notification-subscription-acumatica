# Non-Functional Requirements

## Conventions

- Priority: **MUST** = required for MVP; **SHOULD** = expected but degradable.
- Numeric targets marked *(target — confirm)* are assumptions pending customer input (see Open Questions).
- Load basis: mid-market Acumatica instance, 50–500 users, up to ~3,000 active subscriptions.

## Performance

| ID | Priority | Requirement |
|---|---|---|
| NFR-001 | SHOULD | Time from event receipt to notification dispatch is p95 ≤ 30s under expected load *(target — confirm)*. |
| NFR-002 | SHOULD | Management UI list and edit operations respond within 2s *(target — confirm)*. |

## Scalability

| ID | Priority | Requirement |
|---|---|---|
| NFR-010 | SHOULD | The system handles the event volume of the load basis without architecture change. The Event Processor supports horizontal scaling (additional consumers on the same queue). |

## Reliability

| ID | Priority | Requirement |
|---|---|---|
| NFR-020 | MUST | Guaranteed delivery: an event is acknowledged only after successful processing; failed processing is retried; after N attempts the message is routed to a dead-letter queue (FR-044). No silent loss. |
| NFR-021 | SHOULD | Delivery is at-least-once; processing tolerates event redelivery without producing inconsistent state. |
| NFR-022 | SHOULD | Management-plane availability target 99.5% *(target — confirm)*, bounded by host ERP and infrastructure. |

## Security

| ID | Priority | Requirement |
|---|---|---|
| NFR-030 | MUST | Authentication is delegated to Acumatica SSO; the Subscription Service stores no credentials (FR-001). |
| NFR-031 | MUST | Authorization is role-based; a User can access only their own data (FR-002). |
| NFR-032 | MUST | Filter conditions are stored and evaluated as structured data, never as executable SQL; user input cannot inject queries. |
| NFR-033 | SHOULD | Contact details and notification content are transmitted over TLS and access-controlled. |

## Usability

| ID | Priority | Requirement |
|---|---|---|
| NFR-040 | SHOULD | A non-technical user can configure a subscription without a query language; conditions are built from field / operator / value controls. |
| NFR-041 | SHOULD | The UI is embedded in the ERP and consistent with its navigation and session. |

## Maintainability and extensibility

| ID | Priority | Requirement |
|---|---|---|
| NFR-050 | SHOULD | Application logic is entity-agnostic: a single subscription model serves any entity type, and filter conditions are generic `{field, operator, value}` rows rather than entity-specific code. Adding an entity type or filterable field is a configuration change (which fields are filterable). The allowed entity set is validated at the data layer; extending that set is a minor change, not a structural one. |
| NFR-051 | SHOULD | Event matching and template rendering are channel-agnostic: adding a channel requires no change to matching or rendering, and channel-specific logic is isolated to the Delivery Service. The allowed channel set is validated at the data layer; extending it is a minor change. |

## Observability

| ID | Priority | Requirement |
|---|---|---|
| NFR-060 | SHOULD | Every notification attempt is recorded with status and timestamp (FR-050); the dead-letter queue is monitored. |