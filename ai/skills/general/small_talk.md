# Skill: Greetings & Polite Closings (`small_talk`)

## 1. Skill Name
`general/small_talk`

## 2. Description
Handles basic conversational greetings, thank yous, and polite farewells.

## 3. Purpose
Maintains a warm, friendly customer service tone without triggering unnecessary backend tool invocations.

## 4. Trigger Conditions
- Customer sends "Hello", "Thank you", "Good morning", or "Goodbye".

## 5. Inputs
- `text` (string)

## 6. Outputs
- Polite response string.

## 7. Required APIs
None.

## 8. Error Handling
None.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "general/small_talk",
  "text": "Thank you for your help!"
}
```

## 10. Example Responses

### Small Talk Output
```json
{
  "response": "You're very welcome! Have a wonderful day, and feel free to reach out if you need anything else.",
  "confidence": 0.99
}
```

## 11. Edge Cases
- Mixed greeting and issue ("Hi, my order is missing"): Routes to `order_inquiry` skill instead of `small_talk`.

## 12. Notes
- Low risk, autonomous handling permitted.
