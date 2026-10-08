# Model Selection Matrix (`models`)

## Overview
Maps task types (intent classification, draft generation, summarization, critic scoring) to specific models across cost/latency tiers.

---

## Task-to-Model Routing Matrix

| Task Type | Target Model | Max Latency SLA | Target Cost / 1k Tokens |
| :--- | :--- | :--- | :--- |
| `intent_classification` | `gemini-1.5-flash` | 200ms | $0.0001 |
| `rag_ranking` | `bge-reranker-large` | 100ms | $0.00005 |
| `draft_generation` | `claude-3-5-sonnet` | 1200ms | $0.003 |
| `thread_summarization` | `gpt-4o-mini` | 600ms | $0.00015 |
| `critic_scoring` | `gpt-4o-mini` | 400ms | $0.00015 |

---

## Related Files
- [providers.md](providers.md)
- [token_limits.md](token_limits.md)
