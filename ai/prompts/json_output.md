# JSON Output Enforcement Prompt

## Purpose
A strict enforcement overlay injected when the platform requires a guaranteed valid JSON output from the model — used for schema-sensitive operations such as plan generation, critic scoring, and router classification.

## Template

```
IMPORTANT: You MUST output ONLY valid JSON. No markdown formatting, no explanation text, no code fences.
Your entire response will be parsed directly as JSON. Any non-JSON output will cause an error.

Expected schema: {{schema_name}}
Schema reference: ai/schemas/{{schema_file}}

Produce a response that validates against the above schema, with all required fields present.
```

## Related Files
- [developer.md](developer.md)
- [../shared/conventions.md](../shared/conventions.md)
- [../schemas/](../schemas/)
