# Open Questions

Items that are underdefined in the assignment and would be confirmed with the customer before build.

1. **Event payload contents.** Do Acumatica Business Events include the changed field values in the event, or only entity identity? This determines whether the matcher can evaluate filter conditions from the event alone, or must call back to the ERP for current state.

2. **Source of the "admin" role.** Is Administrator a role managed in Acumatica (reusing ERP roles), or specific to the Subscription Service? This affects where authorization is resolved.

3. **Source of recipient contact details.** Are email/phone taken from the ERP user profile, or entered by the user in the Subscription Service (FR-060)?

4. **Expected scale.** Number of users and event volume per instance, to validate the ~3,000 active-subscription sizing assumption and the queue capacity.

5. **Template lifecycle rules.** What happens to subscriptions referencing a template that an Administrator disables? How are empty or unknown variables rendered (FR-031)?

6. **Recipient scope.** Are notifications only for internal ERP users, or can external customers be recipients? (Currently scoped to internal users.)

7. **Delivery SLA.** Expected latency and delivery guarantees, to fix the numeric targets in the non-functional requirements (NFR-001, NFR-022).
