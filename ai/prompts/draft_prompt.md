# Draft Suggestion Prompt Template

## Purpose
Prompt template used to generate suggested response drafts for human support agents to review in the Flutter mobile application.

## Template

```markdown
Generate a suggested support response draft for a human agent to review.

## Customer Query
"{{customer_message}}"

## Conversation History (Last N turns)
{{conversation_history}}

## Retrieved Context / Knowledge
{{retrieved_context}}

## Guidelines
- Format the response as a ready-to-send draft.
- Keep the draft under 200 words.
- Include placeholders like `[Agent Name]` if applicable.
- Output JSON matching `schemas/draft_suggestion.json`.

```json
{
  "draft_id": "draft_{{uuid}}",
  "chat_id": {{chat_id}},
  "suggested_text": "...",
  "confidence": 0.85,
  "intent": "{{intent}}"
}
```
```

## Related Files
- [system.md](system.md)
- [../schemas/draft_suggestion.json](../schemas/draft_suggestion.json)
- [../skills/support/draft_reply.md](../skills/support/draft_reply.md)
