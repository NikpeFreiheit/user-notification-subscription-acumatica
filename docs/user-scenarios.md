# User scenarios

## Internal ERP User Scenario
An Internal ERP User accesses the subscription management interface in the ERP system to configure notification settings, including subscription rules, template selection or custom notification text, and delivery channels.

When changes occur in relevant business entities, the system evaluates the configured subscription rules and generates notifications based on the selected templates or custom text.

As a result, the user receives notifications about entity changes that match their configured subscriptions.

## Manager / Dispatcher Scenario
A Manager/Dispatcher configures subscriptions to receive notifications about specific Case-related events.

The system sends notifications when:

- a Case is created or updated with High priority
- a Case status changes to “Escalated”
- an Appointment is created and its scheduled date falls within a configured date range

Based on these notifications, the manager can respond to priority changes and track scheduled work within the defined time window.

## Agent / Technician Scenario
An Agent/Technician receives notifications when a new Case is created and assigned to them.

The system also sends notifications when an Appointment is created and assigned to the agent, with a scheduled date that falls within a configured date range.

The agent uses this information to manage assigned work and plan upcoming appointments according to scheduled dates.

## Internal ERP Administrator Scenario
An Internal ERP Administrator manages subscription configurations and notification templates at the system level.

The administrator can create and update templates, modify subscription rules, disable outdated configurations, and adjust recipient settings when organizational roles change.

Changes are applied to all relevant subscriptions and are used for subsequent notification processing.