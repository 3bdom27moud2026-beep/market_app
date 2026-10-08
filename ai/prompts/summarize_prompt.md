# Thread Summarization Prompt Template

## Purpose
Prompt template used by the Summarizer Agent to condense long support conversation histories into structured executive summaries.

## Template

```markdown
Summarize the following customer support conversation thread for a human agent handover.

## Customer Thread History
{{thread_messages}}

## Guidelines
- Extract main topic, sentiment, key facts, and recommended next action.
- Output strictly valid JSON matching `schemas/thread_summary.json`.

```json
{
  "summary_id": "sum_{{uuid}}",
  "chat_id": {{chat_id}},
  "customer_name": "{{customer_name}}",
  "topic": "...",
  "sentiment": "positive|neutral|frustrated|critical",
  "key_points": ["Point 1", "Point 2"],
  "recommended_action": "..."
}
```
```

## Related Files
- [system.md](system.md)
- [../schemas/thread_summary.json](../schemas/thread_summary.json)
- [../skills/support/summarize_thread.md](../skills/support/summarize_thread.md)
