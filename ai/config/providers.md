# Multi-Provider Configuration (`providers`)

## Overview
Specification for supported LLM providers (OpenAI, Google Gemini, Anthropic) and API key configuration management.

---

## Provider Registry

| Provider ID | Primary Model | Fallback Model | Base Endpoint |
| :--- | :--- | :--- | :--- |
| `openai` | `gpt-4o` | `gpt-4o-mini` | `https://api.openai.com/v1` |
| `gemini` | `gemini-1.5-pro` | `gemini-1.5-flash` | `https://generativelanguage.googleapis.com/v1beta` |
| `anthropic` | `claude-3-5-sonnet` | `claude-3-haiku` | `https://api.anthropic.com/v1` |

---

## Related Files
- [models.md](models.md)
- [cost_control.md](cost_control.md)
