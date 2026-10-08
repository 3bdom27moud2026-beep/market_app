# Action Specification: Assign Agent (`assign_agent`)

## Overview
Assigns or reassigns an active chat thread to a specific human support agent or department queue.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Parent conversation ID |
| `user_id` | integer | No | Target support agent user ID (null = unassigned queue) |
| `department` | string | No | Department queue (`billing`, `tech_support`, `general`) |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/chats/{chatId}/assign`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/escalations/escalations_domain.md](../../domains/escalations/escalations_domain.md)
