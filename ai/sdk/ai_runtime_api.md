# Customer Support AI Runtime — OpenAPI 3.1 REST Specification

## Overview
Complete OpenAPI 3.1 REST API specification for the **Customer Support AI Runtime** microservice.

---

## 1. Base Server & Auth

- **Base URL**: `https://ai-runtime.weoryx.com/api/v2`
- **Authentication**: `Authorization: Bearer <service_token>`
- **Idempotency**: All POST requests accept header `X-Idempotency-Key: <uuid>`

---

## 2. API Endpoint Matrix

| Method | Path | Summary | Input Payload | Output Payload |
| :--- | :--- | :--- | :--- | :--- |
| `POST` | `/generate-draft` | Generate draft response for agent review | `chat_id`, `message` | `schemas/draft_suggestion.json` |
| `POST` | `/auto-reply` | Process inbound message for auto-reply | `chat_id`, `message` | `schemas/chat_message.json` |
| `POST` | `/summarize` | Generate thread executive summary | `chat_id` | `schemas/thread_summary.json` |
| `POST` | `/classify` | Classify intent, sentiment & urgency | `text` | `schemas/intent_classification.json` |
| `POST` | `/detect-escalation` | Evaluate thread escalation state | `chat_id` | `schemas/escalation_event.json` |

---

## 3. OpenAPI 3.1 Spec Schema (JSON)

```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "Customer Support AI Runtime API",
    "version": "2.0.0",
    "description": "Production AI Runtime API for Inbox Automation"
  },
  "servers": [
    { "url": "https://ai-runtime.weoryx.com/api/v2" }
  ],
  "paths": {
    "/generate-draft": {
      "post": {
        "summary": "Generate Draft Suggestion",
        "operationId": "generateDraft",
        "responses": {
          "200": { "description": "Draft suggestion generated successfully" },
          "422": { "description": "Validation error" }
        }
      }
    }
  }
}
```

---

## 4. Rate Limits & Errors
- Rate Limit: 300 requests / minute per client token.
- Standard error responses conform to `schemas/api_error.json`.

---

## Related Files
- [../tools/laravel_proxy_api.md](../tools/laravel_proxy_api.md)
- [../schemas/api_error.json](../schemas/api_error.json)
