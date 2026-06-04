# Filter Conditions

In there document we cave Dependencies on **Acumatica Business Events** — the source of entity-change events.
We assume that Business Events have the message and it has the form like

```
{ entity_type: Case, 
id: 1234, 
event_type: Updated, 
fields: { 
    priority: High, 
    status: Escalated, 
    assigned_to: 56 }
 }
 ```
Matcher get filter conditions from Database and compare that with event message
event_type `Created` or `Updated`

## Case Filter Conditions
| Parameter |	Description |
|---|---|
|Entity| Case |
|Field|	Status, Priority, Assigned to |
|Comparison Operator| 1. Status comparison operator `=` <br> 2. Event type comparison operator `=` <br> 3. Priority comparison operator `=` <br> 4. Assigned to comparison operator `=`|
|Value used in the comparison| 1. Status: `Escalated` <br> 3. Priority: `High` <br> 4. Assigned to: `user_id` |

## Appointment Filter Conditions
| Parameter | Description |
|---|---|
| Entity | Appointment |
| Field | Channel, Event Type, Assigned To, Created Date, Scheduled Date |
| Operator | 1. Event Type: `=` <br> 2. Assigned To: `=` <br> 3. Created Date: `On`, `On or After`, `On or Before`, `Between` <br> 4. Scheduled Date: `On`, `On or After`, `On or Before`, `Between` |
| Value Used in the Comparison | 1. Event Type: `Created` <br> 2. Assigned To: `user_id` <br> 3. Created Date: manual entry (`DD.MM.YYYY`) or Date Picker <br> 4. Scheduled Date: manual entry (`DD.MM.YYYY`) or Date Picker |
| Date Range Selection | For the `Between` operator, users select **From** and **To** dates. Both boundary dates are included in the filter results (`>= From` and `<= To`). |


