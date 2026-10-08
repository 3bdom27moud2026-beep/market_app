# Schema & Prompt Migration Protocol

## Overview
This document defines backward-compatibility guidelines, schema deprecation rules, and migration steps for updating AI components in production.

---

## Zero-Downtime Migration Process

```mermaid
sequenceDiagram
    participant Dev as Developer
    participant Registry as Schema Registry
    participant Router as Prompt Router
    participant Agent as Agent Pipeline

    Dev->>Registry: Register v2 Schema (Non-breaking additive)
    Registry->>Router: Update Router with dual v1/v2 support
    Router->>Agent: Route requests to v2 format
    Agent->>Registry: Deprecate v1 Schema (Grace period 30 days)
    Registry->>Agent: Sunset v1 Schema
```

---

## Breaking Change Guidelines
1. **Never delete JSON Schema fields directly**: Mark deprecated fields with `"deprecated": true` in JSON Schema.
2. **Dual-Prompt Buffering**: When upgrading system prompts, run shadow evaluation using `ai/evaluation/benchmarks.md` before deprecating legacy prompts.
3. **Tool Version Fallback**: If an external API tool version changes, update `ai/tools/<tool_name>.md` and define retry fallback in `ai/brain/recovery.md`.
