# Customer Profile Context Buffer (`customer_profile`)

## 1. Overview
Defines sanitized customer CRM context buffer injected alongside working memory.

## 2. Purpose
Provides customer tier, preferred locale, and recent order IDs to the prompt builder.

## 3. Responsibilities
- Store customer tier, display name, and active order IDs.
- Mask sensitive PII before prompt injection.

## 4. Inputs
- `Customer` entity objects.

## 5. Outputs
- Sanitized customer context block.

## 6. Dependencies
- `tools/crm_customer_api.md`
- `brain/safety.md`

## 7. Related Files
- [working_memory.md](working_memory.md)
- [../domains/customers/customers_domain.md](../domains/customers/customers_domain.md)
