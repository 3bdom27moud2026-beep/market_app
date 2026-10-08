# Clarification Request Prompt Template

## Purpose
Prompt triggered when the Brain's confidence score falls between 40-70%, requiring clarification from the user before proceeding with tool execution.

## Template

```
The user's request is ambiguous. Ask ONE specific clarifying question to resolve the ambiguity.

## User Message
"{{user_message}}"

## Ambiguity Detected
{{ambiguity_reason}}

## Rules
- Ask only ONE question — never multiple.
- Be specific: propose 2-3 answer options where possible.
- Keep the question under 30 words.
- Maintain the friendly, professional tone from brain/personality.md.

## Example Outputs
- "Are you looking for events in Paris, France or Paris, Texas?"
- "Would you like budget options (under $100) or luxury hotels?"
- "Do you need directions by car, public transit, or walking?"
```

## Related Files
- [../brain/confidence.md](../brain/confidence.md)
- [../brain/conversation_flow.md](../brain/conversation_flow.md)
- [../agents/coordinator.md](../agents/coordinator.md)
