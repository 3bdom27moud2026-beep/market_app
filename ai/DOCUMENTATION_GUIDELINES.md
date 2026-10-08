# Documentation Standards & Guidelines

## Generation Rules

1. **Zero Placeholders**: Never include "TODO", "TBD", or incomplete sections. Every document must contain production-ready, complete documentation.
2. **Relative Cross-References**: Every document MUST link to related files using **relative Markdown links** (e.g. `[routing.md](../brain/routing.md)`). Never use `file:///` or absolute paths — they break portability across GitHub, macOS, Linux, Cursor, VS Code Remote, and GitLab.
3. **Mermaid Diagrams**: Include Mermaid diagrams (`flowchart`, `sequenceDiagram`, `stateDiagram-v2`) in all key specification files to visualize relationships and control flow.
4. **Consistency**: Reuse terminology from the [glossary](../shared/glossary.md) consistently. Never duplicate responsibility definitions between layers.
5. **Dependency Rule**: Every directory must only depend on layers below it in the [layer dependency hierarchy](#layer-dependency-hierarchy). No component may reference higher-level layers or create circular dependencies.

---

## Layer Dependency Hierarchy

```
Agents              (top - orchestration)
    ↓
Brain               (cognitive logic)
    ↓
SDK                 (interface contracts)
    ↓
Execution           (state management)
    ↓
Memory              (context storage)
    ↓
MCP                 (protocol adapters)
    ↓
Skills              (domain capabilities)
    ↓
Tools               (API wrappers)
    ↓
Schemas             (data contracts)
    ↓
Shared              (constants, utilities)
    ↓
External APIs       (third-party services)
```

### Allowed & Forbidden Dependencies

| Layer | Allowed Dependencies | Forbidden From |
| :--- | :--- | :--- |
| `agents/` | `brain/`, `sdk/`, `execution/`, `memory/`, `shared/` | `skills/`, `tools/`, `schemas/` (use sdk contracts only) |
| `brain/` | `shared/`, `config/` | `agents/`, `skills/`, `tools/` |
| `sdk/` | `shared/`, `schemas/` | `agents/`, `brain/`, `skills/`, `tools/` |
| `execution/` | `sdk/`, `shared/`, `schemas/` | `agents/`, `brain/` |
| `memory/` | `schemas/`, `shared/` | `agents/`, `brain/`, `skills/`, `tools/` |
| `mcp/` | `sdk/`, `schemas/`, `shared/` | `agents/`, `brain/`, `memory/` |
| `skills/` | `schemas/`, `shared/`, `knowledge/` | `agents/`, `brain/`, `sdk/` |
| `tools/` | `schemas/`, `shared/` | `agents/`, `brain/`, `sdk/`, `skills/` |
| `schemas/` | (none — leaf layer) | All upper layers |
| `shared/` | (none — root layer) | All upper layers |

---

## Standard 14-Section Markdown Template

Every specification markdown file in `ai/` must adhere to this structure:

```markdown
# [Component Name]

## 1. Overview
## 2. Purpose
## 3. Responsibilities
## 4. Inputs
## 5. Outputs
## 6. Dependencies
## 7. Related Files          ← relative links only
## 8. Sequence Diagram / Workflow  ← Mermaid required
## 9. Examples
## 10. Edge Cases
## 11. Error Handling
## 12. Extension Points
## 13. API & Schema Versioning
## 14. References
```

---

## Standard 12-Point Skill Schema
Every skill document under `ai/skills/` must include:
1. Skill Name, 2. Description, 3. Purpose, 4. Trigger Conditions, 5. Inputs, 6. Outputs, 7. Required APIs, 8. Error Handling, 9. Example Requests, 10. Example Responses, 11. Edge Cases, 12. Notes.

---

## Standard Tool Schema
Every tool document under `ai/tools/` must include:
- API version, endpoint, authentication, request schema, response schema, error codes, rate limits, retry policy, cache strategy, deprecation policy.

---

## JSON Schema Rules
All files under `ai/schemas/` must be valid **Draft 2020-12 JSON Schema** (`.json` extension) with: `$schema`, `$id`, `title`, `type`, `properties`, `required`, `examples`.

---

## Naming Conventions
- Files: `snake_case.md`, `snake_case.json`
- JSON keys: `snake_case`
- See [conventions.md](../shared/conventions.md) for full rules.
