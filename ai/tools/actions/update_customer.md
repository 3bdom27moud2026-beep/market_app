# Action Specification: Update Customer (`update_customer`)

## Overview
Updates customer profile metadata in the CRM database.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `customer_id` | integer | Yes | Target customer ID |
| `email` | string | No | Updated email |
| `locale` | string | No | Preferred language locale |

---

## 2. API Endpoint Mapping
- **Method**: `PUT`
- **Path**: `/customers/{customerId}`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/customers/customers_domain.md](../../domains/customers/customers_domain.md)
