# Tool Call Prompt Template

## Purpose
Minimal prompt injected immediately before a single tool invocation to ensure the model outputs a clean, schema-valid tool call JSON object.

## Template

```
Output ONLY a valid JSON tool call object to invoke the following tool.

Tool: {{tool_name}}
Description: {{tool_description}}
Required Parameters: {{parameter_schema}}
Current Context: {{resolved_context}}

Rules:
- Do not include markdown or explanation.
- All required parameters must be present with correct types.
- Use null for optional parameters that cannot be resolved from context.

Output:
```json
{ "tool": "{{tool_name}}", "parameters": { ... } }
```
```

## Related Files
- [../sdk/tool_contract.md](../sdk/tool_contract.md)
- [../schemas/tool_call.json](../schemas/tool_call.json)
- [json_output.md](json_output.md)
