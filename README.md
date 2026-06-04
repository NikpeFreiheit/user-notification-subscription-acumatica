# User Notification Subscription for Acumatica

Specification (SRS) for a self-service tool that lets Acumatica users subscribe to notifications about entity changes — for example escalated Cases or newly created Appointments — configure the conditions, the notification text, and the delivery channel, and lets both users and administrators manage their subscriptions.

This repository contains the full specification: user scenarios, requirements, proposed solution, data model, API, and UI mockups.

## Where to start

Open **[index.md](index.md)** — the specification's table of contents and recommended reading order.

The original assignment this responds to: [test-requirements.md](test-requirements.md).

## Repository layout

- `index.md` — specification entry point and reading order
- `test-requirements.md` — the original assignment
- `docs/` — the specification
  - narrative sections: executive summary, glossary, scenarios, requirements, scope & solution, filters, templates, API, roadmap, open questions
  - `architecture/` — C4 (context, container, component) and sequence diagrams (PlantUML)
  - `data-model/` — PostgreSQL schema and ER model
  - `mockups/` — UI wireframes (PlantUML Salt)
