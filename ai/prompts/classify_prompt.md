# Intent Classification Prompt Template

## Purpose
Prompt template used by the Reasoning module to classify customer intent and extract entities.

## Template

```markdown
Analyze the incoming customer support message and classify intent, sentiment, urgency, and entities.

## Inbound Message
"{{customer_message}}"

## Allowed Intents
- `faq_hours`: Business hours and operating days
- `faq_location`: Physical location and store addresses
- `order_inquiry`: Order tracking, status, and delivery inquiries
- `cancellation`: Order or subscription cancellation requests
- `billing_dispute`: Refund requests, payment errors, overcharge complaints
- `complaint`: General dissatisfaction or product/service issues
- `general_inquiry`: Other general questions

## Guidelines
- Output strictly valid JSON matching `schemas/intent_classification.json`.

```json
{
  "intent": "...",
  "confidence": 0.95,
  "sentiment_score": 0.0,
  "urgency": "low|medium|high|critical",
  "entities": {
    "order_id": null
  }
}
```
```

## Related Files
- [../brain/reasoning.md](../brain/reasoning.md)
- [../schemas/intent_classification.json](../schemas/intent_classification.json)
