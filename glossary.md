# Glossary
## Project context
**Subscription Service** - Software, который потребляет entity-change события из существующего механизма Acumatica Business Event via RMQ, выполняет матчинг полученных событий с параметрами подписки Users, генерирует текст сообщения для уведомления User и передает его в Delivery Service.

**Acumatica Business Event** - Механизм событийно-ориентированной автоматизации в Acumatica, который позволяет системе отслеживать изменения данных, действия пользователей или выполнение определённых условий и автоматически запускать заранее настроенные действия без необходимости ручного контроля. Позволяет реагировать на изменения в системе и запускать уведомления, интеграции, отчёты или кастомную логику на основе бизнес-событий.

**Event-driven via RabbitMQ** - Архитектурный подход с использованием брокера сообщений RabbitMQ для асинхронного взаимодействия между **Acumatica Business Event** и **Subscription Service**

## Filter context

**Entity type** - 

**Channel** -

**Event type** -

**Field** -

**Filter condition** - 

**Subscription** — центральный объект (entity_type + event_type + filter conditions + channel + template)

**Notification Template** - 

**Custom plain-text** - 

**Subject/note** - 

**Delivery Service** - 

**Event types** -  Created / Updated / Deleted — твой словарь событий