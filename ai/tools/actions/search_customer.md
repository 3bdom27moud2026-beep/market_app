# Action Specification: Search Customer (`search_customer`)

## Overview
Searches CRM customer profiles by phone number, email, or order ID.

---

## 1. Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `query` | string | Yes | Phone number, email address, or customer ID |

---

## 2. API Endpoint Mapping
- **Method**: `GET`
- **Path**: `/customers/search?q={query}`

---

## Related Files
- [../registry.md](../registry.md)
- [../../domains/customers/customers_domain.md](../../domains/customers/customers_domain.md)
