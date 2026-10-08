# Customers Domain Business Logic Specification

## 1. Overview
The Customers Domain handles customer profile context, CRM lookups, language preferences, and historical interaction metadata.

## 2. Purpose
Provides rich customer context to the AI microservice for personalized draft generation and intent evaluation.

## 3. Responsibilities
- Fetch customer profile data (`id`, `name`, `phone_number`, `email`, `locale`).
- Retrieve customer VIP tier or loyalty status.
- Mask customer PII before sending context to LLM prompts.

## 4. Inputs
- `Customer` entity objects from backend database.

## 5. Outputs
- Sanitized customer context buffer.

## 6. Dependencies
- `brain/safety.md`
- `tools/crm_customer_api.md`

## 7. Related Files
- [../chats/chats_domain.md](../chats/chats_domain.md)
- [../../tools/crm_customer_api.md](../../tools/crm_customer_api.md)
- [../../brain/safety.md](../../brain/safety.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Customer Profile Entity
```json
{
  "id": 1009,
  "name": "Ahmed Al-Rashid",
  "phone_number": "+20 10 30082605",
  "email": "ahmed@example.com",
  "locale": "en_US",
  "tier": "VIP"
}
```

## 10. Edge Cases
- Anonymous customer (no CRM match): System uses display name from WhatsApp profile or defaults to "Customer".

## 11. Error Handling
- Customer API lookup timeout proceeds with basic thread context.

## 12. Extension Points
- CRM custom field mappings per enterprise client.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- Flutter entity: `lib/features/home/domain/entites/sub_entites/customer.dart`
