# Template Variables

## Purpose

Template variables are placeholders in a notification template that are replaced with data from the triggering event at render time, so a notification is specific ("Case #1234 escalated") rather than generic ("a case was escalated").

- **Distinct from filter conditions.** Filter conditions decide *whether* to send; template variables decide *what the message says*. Both draw from the same event but for opposite purposes, so their field sets differ (e.g. `record_link` is shown but never filtered on).
- Admin-owned templates may contain variables. A user's optional custom text is plain — it does not support substitution.

## Supported variables (MVP)

| Variable | Description | Entity |
|---|---|---|
| `{entity_type}` | Entity that triggered the notification (Case / Appointment) | both |
| `{entity_id}` | Record identifier (e.g. Case number) | both |
| `{record_link}` | Direct link to open the record in the ERP | both |
| `{event_type}` | Created / Updated | both |
| `{assigned_to}` | Display name of the assigned user | both |
| `{priority}` | Case priority value | Case |
| `{status}` | Case status value | Case |
| `{scheduled_date}` | Appointment scheduled date | Appointment |
| `{created_date}` | Appointment creation date | Appointment |

## Rules

- Available variables depend on the entity (e.g. `{priority}` only for Case).
- Variables are validated when a template is saved; unknown variables are rejected.
- A variable with no value in the event payload renders per a defined fallback (to confirm — Open Questions).
- Availability of display values (e.g. `{assigned_to}` name vs. id, `{record_link}`) depends on the event payload from Business Events (to confirm — Open Questions).

## Example

Template:

```
Case {entity_id} changed to {status}. Open: {record_link}
```

Rendered:

```
Case #1234 changed to Escalated. Open: https://erp.example/.../1234
```