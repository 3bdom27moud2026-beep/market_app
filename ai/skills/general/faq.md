# Skill: Knowledge Base Query (`faq`)

## 1. Skill Name
`general/faq`

## 2. Description
Queries the company knowledge base for answers to common customer questions.

## 3. Purpose
Provides instant, accurate information on business hours, shipping policies, returns, and store locations.

## 4. Trigger Conditions
- Intent classified as `faq_hours`, `faq_location`, or standard policy inquiry.

## 5. Inputs
- `query` (string)

## 6. Outputs
- Answer string and confidence score.

## 7. Required APIs
None (internal knowledge search).

## 8. Error Handling
- No matching FAQ returns confidence `0.00` to trigger draft or escalation mode.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "general/faq",
  "query": "What is your return policy?"
}
```

## 10. Example Responses

### FAQ Output
```json
{
  "answer": "Items can be returned within 30 days of purchase with original receipt.",
  "confidence": 0.95,
  "source_document": "returns_policy.md"
}
```

## 11. Edge Cases
- Outdated policy query: Returns latest published policy version.

## 12. Notes
- Ground truth context loaded from `ai/knowledge/`.
