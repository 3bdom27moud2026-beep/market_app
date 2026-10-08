# Action Specification: Change Status (`change_status`)

## Overview
Updates thread status flags (`readStatus`, `unreply`, `priority`).

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Target conversation ID |
| `read_status` | string | No | `read` or `unread` |
| `unreplied` | integer | No | `0` (replied) or `1` (unreplied) |
| `priority` | string | No | `low`, `medium`, `high`, `urgent` |

---

## 2. API Endpoint Mapping
- **Method**: `PUT`
- **Path**: `/chats/{chatId}/status`

---

## Related Files
- [../registry.md](../registry.md)
