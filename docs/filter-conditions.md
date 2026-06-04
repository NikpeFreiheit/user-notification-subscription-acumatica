# Filter Conditions

## Model

A subscription matches an event when its filter conditions evaluate to true against the event data.

- A condition is `{field, operator, value}`.
- A subscription has zero or more conditions, combined with `AND` (MVP). `OR` / `NOT` → Phase 2.
- `entity_type`, `event_type`, and `channels` are **subscription attributes, not filter conditions**: they select which events to consider and how to deliver, not which field values to match.
- Matching uses **state** semantics: for an `Updated` event, a condition matches the resulting field value. Transition semantics (field *changed to* value) → Phase 2.

## Filterable fields per entity

| Entity | Field | Type |
|---|---|---|
| Case | Priority | picklist |
| Case | Status | picklist |
| Case | Assigned To | reference (user) |
| Appointment | Created Date | date |
| Appointment | Scheduled Date | date |
| Appointment | Assigned To | reference (user) |

Adding a new entity = adding rows here, not changing code.

## Operators by field type

| Field type | Operators (MVP) | Phase 2 |
|---|---|---|
| picklist | `=` | `in`, `≠` |
| date | `=`, `before`, `after`, `between` | relative ranges |
| number | `=`, `<`, `>`, `between` | — |
| text | `=`, `contains` | — |
| boolean | `=` | — |
| reference (user) | `=`, where value `me` resolves to the current user_id | — |

For `between` (date / number), both bounds are inclusive (`>= from AND <= to`).

## Condition values in MVP scope

- Case Priority `=` High
- Case Status `=` Escalated
- Case / Appointment Assigned To `=` me (current user_id)
- Appointment Created Date / Scheduled Date `between` from–to

## Example

Notify me when a Case is escalated:

```
entity_type: Case
event_types: [Updated]
logic: AND
conditions:
  - { field: Status, operator: "=", value: "Escalated" }
channels: [Email]
```