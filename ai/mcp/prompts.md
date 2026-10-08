# MCP Server Prompt Ingestion

## 1. Overview
Allows MCP servers to export prompt templates dynamically to the platform's prompt registry in `ai/prompts/`.

## 2. Purpose
Enables external services to supply tailored system or tool prompts.

## 3. Responsibilities
- Discover prompts via `prompts/list`.
- Render prompt arguments safely.

## 4. Inputs
Prompt names & parameter bindings.

## 5. Outputs
Rendered prompt string.

## 6. Dependencies
- [system.md](file:///c:/Users/bss/studio%20projects/chat_app/ai/prompts/system.md)

## 7. Related Files
- [registry.md](file:///c:/Users/bss/studio%20projects/chat_app/ai/mcp/registry.md)

## 8. Sequence Diagram / Workflow
```mermaid
flowchart LR
    MCPServer[MCP Server] --> PromptsList[prompts/list]
    PromptsList --> PromptRegistry[ai/prompts/ Router]
```

## 9. Examples
```json
{
  "name": "summarize_travel_itinerary",
  "description": "Template for formatting trip plans",
  "arguments": [
    {"name": "destination", "required": true}
  ]
}
```

## 10. Edge Cases
Prompt parameter mismatches trigger validation error.

## 11. Error Handling
Falls back to system prompt template in `ai/prompts/developer.md`.

## 12. Extension Points
Support multi-lingual prompt templates.

## 13. API & Schema Versioning
MCP Prompt Spec: 1.0.0

## 14. References
- MCP Prompt Protocol.
