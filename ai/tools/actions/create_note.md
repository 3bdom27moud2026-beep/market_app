# Action Specification: Create Internal Note (`create_note`)

## Overview
Attaches a private internal note to a chat thread visible only to human support agents.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Parent conversation ID |
| `note_text` | string | Yes | Internal note text |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/chats/{chatId}/notes`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/chats/chats_domain.md](../../domains/chats/chats_domain.md)
