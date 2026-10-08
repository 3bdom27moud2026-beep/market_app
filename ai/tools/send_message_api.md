# Tool Specification: Send Message API (`send_message_api`)

## Overview
Specification for sending text or media messages to WhatsApp/Messenger via the Laravel backend.

---

## 1. Endpoint & Method

- **Method**: `POST`
- **Endpoint**: `/send-message`
- **Content-Type**: `application/json` or `multipart/form-data`

---

## 2. Request Body Payload

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `channel_id` | integer | Yes | Channel ID |
| `type` | string | Yes | Message type (`text`, `image`, `audio`, `document`) |
| `chat_id` | integer | No | Existing chat ID |
| `message` | string | No | Text content |
| `phone_number` | string | No | Recipient phone number if new chat |
| `file` | file/string | No | Multipart file or file path |

---

## 3. Response Schema
Returns created message object matching `schemas/chat_message.json`.

```json
{
  "message": {
    "id": 99105,
    "chat_id": 4821,
    "sender": "bot",
    "text": "Hello! Your order #58210 is expected today by 5 PM.",
    "type": "text",
    "status": "sent",
    "created_at": "2026-08-04T12:00:05Z"
  }
}
```

---

## 4. Error Handling
- Max attachment size: 25MB.
- `422 Validation Error`: Missing required parameters.

---

## Related Files
- [laravel_proxy_api.md](laravel_proxy_api.md)
- [../schemas/chat_message.json](../schemas/chat_message.json)
