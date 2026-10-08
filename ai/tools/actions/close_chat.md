# Action Specification: Close Chat (`close_chat`)

## Overview
Marks a customer support chat thread as resolved and closed.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Target conversation ID |
| `resolution_reason` | string | Yes | Resolution category (`resolved_by_ai`, `resolved_by_agent`, `customer_inactive`) |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/chats/{chatId}/close`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/chats/chats_domain.md](../../domains/chats/chats_domain.md)
