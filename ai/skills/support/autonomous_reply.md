# Skill: Autonomous Auto-Reply (`autonomous_reply`)

## 1. Skill Name
`support/autonomous_reply`

## 2. Description
Automatically dispatches direct responses to WhatsApp/Messenger for standard queries without requiring human agent approval.

## 3. Purpose
Automates resolution of low-risk, high-frequency customer queries (FAQs, business hours, store locations).

## 4. Trigger Conditions
- Intent classified as `faq_hours`, `faq_location`, or simple greetings.
- Confidence score `>= 0.85`.
- Risk level `Low`.

## 5. Inputs
- `chat_id` (integer)
- `channel_id` (integer)
- `customer_message` (string)

## 6. Outputs
- Dispatched message via `tools/send_message_api.md`.

## 7. Required APIs
- `tools/send_message_api.md`

## 8. Error Handling
- Message send failure triggers `tools/laravel_proxy_api.md` retry mechanism.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "support/autonomous_reply",
  "chat_id": 4821,
  "channel_id": 21,
  "customer_message": "What are your business hours?"
}
```

## 10. Example Responses

### Auto-Reply Response
```json
{
  "status": "sent",
  "message_id": 99105,
  "text": "Our customer support team is available Monday through Saturday from 9:00 AM to 6:00 PM."
}
```

## 11. Edge Cases
- Non-standard hours request: Confirms standard hours and provides online self-service link.

## 12. Notes
- All autonomous replies are logged with `sender = "bot"`.
