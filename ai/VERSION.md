# Versioning Policy

## Semantic Versioning Standard
The AI Agent Platform Architecture uses `MAJOR.MINOR.PATCH` versioning for all prompts, schemas, tools, and agent behaviors.

- **MAJOR version (`X.0.0`)**: Incompatible API schema changes, breaking changes in prompt contracts, removal of agent roles, or major memory model rewrites.
- **MINOR version (`0.X.0`)**: Addition of new skills, tools, MCP servers, domain rules, or non-breaking prompt enhancements.
- **PATCH version (`0.0.X`)**: Documentation fixes, confidence threshold tweaks, minor prompt tuning, or non-functional structural polish.

---

## Current Architecture Version
```yaml
version: 2.0.0
release_date: 2026-08-04
compatibility:
  min_flutter_sdk: 3.11.0
  mcp_spec_version: 1.0.0
  json_schema_draft: 2020-12
```

---

## Component Version Constraints

| Component | Current Version | Compatibility Rule |
| :--- | :--- | :--- |
| `agents/` | v2.0 | Breaking if agent interface signature changes |
| `brain/` | v2.0 | Breaking if decision engine tree contracts change |
| `schemas/` | v2.0 | Strictly enforced via JSON Schema validator |
| `mcp/` | v1.0 | Compatible with standard MCP servers |
