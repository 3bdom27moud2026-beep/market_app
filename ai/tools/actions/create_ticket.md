# Action Specification: Create Ticket (`create_ticket`)

## Overview
Generates a formal CRM support ticket from an active conversation thread.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `chat_id` | integer | Yes | Parent conversation ID |
| `subject` | string | Yes | Ticket title |
| `description` | string | Yes | Detailed problem description |
| `priority` | string | Yes | `low`, `medium`, `high`, `urgent` |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/tickets`

---

## Related Files
- [../registry.md](../registry.md)
