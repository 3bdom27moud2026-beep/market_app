# System Conventions & Standards

## 1. Overview
Defines code, schema, file naming, and API contract conventions enforced across the Customer Support AI Microservice.

## 2. Purpose
Ensures consistency across all layers (agents, brain, prompts, schemas, tools, domain modules).

## 3. Responsibilities
- Define naming rules for files, JSON fields, Dart classes, and API routes.
- Enforce relative markdown cross-referencing rules.

## 4. Inputs
None.

## 5. Outputs
System conventions specification.

## 6. Dependencies
- [glossary.md](glossary.md)

## 7. Related Files
- [../DOCUMENTATION_GUIDELINES.md](../DOCUMENTATION_GUIDELINES.md)
- [glossary.md](glossary.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Naming Standards

| Target | Convention | Example |
| :--- | :--- | :--- |
| Documentation Files | `snake_case.md` | `draft_reply.md` |
| JSON Schema Files | `snake_case.json` | `chat_message.json` |
| JSON Payload Keys | `snake_case` | `"ai_session_id": "sess_123"` |
| Dart Entities | `PascalCase` | `AllChatsEntite` |
| API Endpoints | `kebab-case` or `/chats?type=mine` | `/send-message` |
| Agent Names | `lowercase` | `coordinator`, `planner` |

### Relative Path Rule
All file cross-references MUST use relative paths (e.g. `[routing.md](../brain/routing.md)`). Never use absolute paths or `file:///` URLs.

## 10. Edge Cases
None.

## 11. Error Handling
Lint errors are raised if markdown files violate relative link standards.

## 12. Extension Points
- Rules updated if new language targets are added.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- Dart style guide & JSON Schema Draft 2020-12 specifications.
