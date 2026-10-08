# Skill: Auto-Reply Drafting (`draft_reply`)

## 1. Skill Name
`support/draft_reply`

## 2. Description
Generates a candidate response draft for human support agents to review, edit, or send in the mobile chat screen.

## 3. Purpose
Empowers human support agents to reply faster by pre-populating contextually accurate, policy-compliant response suggestions.

## 4. Trigger Conditions
- Intent classified as `order_inquiry`, `cancellation`, or `general_inquiry`.
- Confidence score between `0.60` and `0.84`.

## 5. Inputs
- `chat_id` (integer)
- `ai_session_id` (string)
- `customer_message` (string)
- `retrieved_context` (object)

## 6. Outputs
- `schemas/draft_suggestion.json` payload.

## 7. Required APIs
- `tools/crm_customer_api.md`
- `tools/chat_messages_api.md`

## 8. Error Handling
- Context fetch timeout defaults to template-based draft proposal.

## 9. Example Requests

### Inbound Skill Request
```json
{
  "skill": "support/draft_reply",
  "chat_id": 4821,
  "ai_session_id": "sess_883921",
  "customer_message": "Where is my order #58210?"
}
```

## 10. Example Responses

### Draft Output
```json
{
  "draft_id": "draft_9901",
  "chat_id": 4821,
  "suggested_text": "Hello Ahmed! Order #58210 is currently out for delivery and expected today by 5 PM.",
  "confidence": 0.82,
  "intent": "order_inquiry"
}
```

## 11. Edge Cases
- Customer asks multiple questions: Draft breaks response into clear numbered points.

## 12. Notes
- Human agent can edit draft directly in Flutter UI before sending.
