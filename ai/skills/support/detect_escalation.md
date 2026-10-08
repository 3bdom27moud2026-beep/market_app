# Skill: Escalation Detection (`detect_escalation`)

## 1. Skill Name
`support/detect_escalation`

## 2. Description
Monitors customer sentiment and confidence triggers to flag threads requiring human agent takeover.

## 3. Purpose
Prevents customer churn and CSAT drops by routing frustrated customers directly to human support teams.

## 4. Trigger Conditions
- Customer sentiment score `< -0.50`.
- Intent confidence `< 0.60`.
- Explicit customer request ("speak to human").

## 5. Inputs
- `chat_id` (integer)
- `ai_session_id` (string)
- `sentiment_score` (number)

## 6. Outputs
- `schemas/escalation_event.json` payload.

## 7. Required APIs
- `tools/laravel_proxy_api.md`

## 8. Error Handling
- Failed escalation notification triggers fallback SMS alert to supervisor.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "support/detect_escalation",
  "chat_id": 4821,
  "ai_session_id": "sess_883921",
  "sentiment_score": -0.75
}
```

## 10. Example Responses

### Escalation Event Output
```json
{
  "escalation_id": "esc_1102",
  "chat_id": 4821,
  "ai_session_id": "sess_883921",
  "reason": "FRUSTRATED_CUSTOMER",
  "escalated_at": "2026-08-04T12:00:10Z"
}
```

## 11. Edge Cases
- False positive anger detection (profanity used casually): Verifier confirms escalation intent before triggering handover alert.

## 12. Notes
- Reassigns chat `type` to `unassigned` in backend API.
