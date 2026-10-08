# Skill: Intent Tagging & Classification (`classify_intent`)

## 1. Skill Name
`support/classify_intent`

## 2. Description
Analyzes incoming customer messages and attaches metadata tags (`intent`, `urgency`, `sentiment`).

## 3. Purpose
Enables automated ticket categorization and inbox sorting in the Flutter mobile application.

## 4. Trigger Conditions
- Every inbound customer message arrival.

## 5. Inputs
- `text` (string)

## 6. Outputs
- `schemas/intent_classification.json` payload.

## 7. Required APIs
None (pure inference skill).

## 8. Error Handling
- Inference failure defaults to `general_inquiry` intent with `0.00` confidence.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "support/classify_intent",
  "text": "Cancel my subscription immediately!"
}
```

## 10. Example Responses

### Classification Output
```json
{
  "intent": "cancellation",
  "confidence": 0.96,
  "sentiment_score": -0.8,
  "urgency": "high"
}
```

## 11. Edge Cases
- Empty message text (media only): Tagged as `media_inquiry`.

## 12. Notes
- Tags are displayed as badges in the Flutter chat list screen.
