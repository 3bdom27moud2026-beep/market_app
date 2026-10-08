# Skill: Thread Summarization (`summarize_thread`)

## 1. Skill Name
`support/summarize_thread`

## 2. Description
Generates a structured executive summary of a customer support conversation thread.

## 3. Purpose
Helps human agents quickly get up to speed when taking over a ticket or reviewing customer history.

## 4. Trigger Conditions
- Human agent opens a chat thread containing > 5 messages.
- Thread escalation event occurs.

## 5. Inputs
- `chat_id` (integer)

## 6. Outputs
- `schemas/thread_summary.json` payload.

## 7. Required APIs
- `tools/chat_messages_api.md`

## 8. Error Handling
- Partial message history produces summary marked with `incomplete_data: true`.

## 9. Example Requests

### Skill Request
```json
{
  "skill": "support/summarize_thread",
  "chat_id": 4821
}
```

## 10. Example Responses

### Summary Payload
```json
{
  "summary_id": "sum_9012",
  "chat_id": 4821,
  "topic": "Order Delay #58210",
  "sentiment": "frustrated",
  "key_points": [
    "Order placed Aug 1.",
    "Delayed at distribution center.",
    "Expedited delivery requested."
  ],
  "recommended_action": "Contact logistics courier."
}
```

## 11. Edge Cases
- Single message thread: Summary skill returns 1-sentence paraphrase.

## 12. Notes
- Summaries are cached in session memory.
