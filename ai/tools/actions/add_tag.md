# Action Specification: Add Tag (`add_tag`)

## Overview
Attaches metadata tags to a customer chat thread for inbox sorting and reporting.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Target conversation ID |
| `tags` | array | Yes | Array of tag strings (`["billing", "vip", "urgent"]`) |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/chats/{chatId}/tags`

---

## Related Files
- [../registry.md](../registry.md)
- [../../skills/support/classify_intent.md](../../skills/support/classify_intent.md)
