# API Specification

Management-plane REST API for the Subscription Service. The event pipeline (Business Events → queue → processor → delivery) is internal and not exposed here.

## Conventions

- Authentication: requests inherit the Acumatica ERP session (FR-001). No separate credentials.
- Authorization: role-based (FR-002). User operations are scoped to the caller; Administrator operations span all users.
- Request/response bodies are JSON. The filter-conditions payload follows `filter-conditions.md`; template variables follow `template-variables.md`.
- No OpenAPI/YAML contract is provided at this stage by choice: at specification level a method/endpoint table is sufficient and avoids over-specifying the wire format before review.

## Subscriptions

| Method | Endpoint | Description | Role |
|---|---|---|---|
| GET | /subscriptions | List subscriptions. User: own only. Administrator: all, with optional owner/entity/status filters. | User / Admin |
| POST | /subscriptions | Create a subscription scoped to the caller. | User / Admin |
| GET | /subscriptions/{id} | Retrieve one subscription. | Owner / Admin |
| PUT | /subscriptions/{id} | Update subscription parameters. | Owner / Admin |
| PATCH | /subscriptions/{id}/status | Enable or disable without deleting. | Owner / Admin |
| DELETE | /subscriptions/{id} | Delete a subscription. | Owner / Admin |

## Templates

| Method | Endpoint | Description | Role |
|---|---|---|---|
| GET | /templates | List templates available for selection. | User / Admin |
| POST | /templates | Create a template. | Admin |
| PUT | /templates/{id} | Update a template. | Admin |
| PATCH | /templates/{id}/status | Enable or disable a template. | Admin |

## Notification history

| Method | Endpoint | Description | Role |
|---|---|---|---|
| GET | /notifications | List notification history. User: own only. Administrator: all. | User / Admin |

## Channel preferences

| Method | Endpoint | Description | Role |
|---|---|---|---|
| GET | /me/channels | Retrieve the caller's contact details. | User / Admin |
| PUT | /me/channels | Update the caller's contact details. | User / Admin |

## Example — create subscription (POST /subscriptions)

```json
{
  "entity_type": "Case",
  "event_types": ["Updated"],
  "conditions": [
    { "field": "Status", "operator": "=", "value": "Escalated" }
  ],
  "channels": ["Email"],
  "template_id": 12,
  "custom_note": "Please review."
}
```