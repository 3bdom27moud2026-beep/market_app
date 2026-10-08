# Tool Specification: Chat Messages API (`chat_messages_api`)

## Overview
Specification for fetching message history for a specific conversation thread from the Laravel backend.

---

## 1. Endpoint & Method

- **Method**: `GET`
- **Endpoint**: `/chat-messages/{chatId}?page={page}`
- **Authentication**: `Bearer <token>`

---

## 2. Request Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chatId` | integer | Yes | Parent conversation ID |
| `page` | integer | No | Pagination page number (default: 1) |

---

## 3. Response Schema
Returns JSON array conforming to `schemas/chat_message.json`.

```json
{
  "messages": [
    {
      "id": 99104,
      "chat_id": 4821,
      "sender": "customer",
      "text": "Where is my order #58210?",
      "type": "text",
      "created_at": "2026-08-04T12:00:00Z"
    }
  ]
}
```

---

## 4. Error Codes & Retries
- `404 Not Found`: Chat ID does not exist.
- `504 Timeout`: Retries up to 3 times.

---

## Related Files
- [laravel_proxy_api.md](laravel_proxy_api.md)
- [../schemas/chat_message.json](../schemas/chat_message.json)
