# Action Specification: Send Template (`send_template`)

## Overview
Dispatches a pre-approved WhatsApp message template (HSM).

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `channel_id` | integer | Yes | Channel ID |
| `template_name` | string | Yes | Name of registered WhatsApp template |
| `phone_number` | string | Yes | Recipient phone number |
| `variables` | object | No | Template placeholder parameters |

---

## 2. API Endpoint Mapping
- **Method**: `POST`
- **Path**: `/send-template`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/channels/channels_domain.md](../../domains/channels/channels_domain.md)
