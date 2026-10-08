# Tool Specification: CRM Customer API (`crm_customer_api`)

## Overview
Specification for fetching customer profile details and CRM context.

---

## 1. Endpoint & Method

- **Method**: `GET`
- **Endpoint**: `/customer/{customerId}`
- **Authentication**: `Bearer <token>`

---

## 2. Request Parameters

| Parameter | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `customerId` | integer | Yes | Customer ID |

---

## 3. Response Schema

```json
{
  "customer": {
    "id": 1009,
    "name": "Ahmed Al-Rashid",
    "phone_number": "+20 10 30082605",
    "email": "ahmed@example.com",
    "tier": "VIP"
  }
}
```

---

## 4. Related Files
- [laravel_proxy_api.md](laravel_proxy_api.md)
- [../domains/customers/customers_domain.md](../domains/customers/customers_domain.md)
