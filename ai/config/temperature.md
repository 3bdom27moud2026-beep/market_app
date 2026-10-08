# Sampling Parameters & Temperature Matrix (`temperature`)

## Overview
Sampling parameters (`temperature`, `top_p`, `frequency_penalty`) per task type to balance creativity and factual precision.

---

## Sampling Parameter Matrix

| Task Type | Temperature | Top P | Frequency Penalty | Description |
| :--- | :--- | :--- | :--- | :--- |
| `intent_classification` | `0.0` | `1.0` | `0.0` | Deterministic, exact classification |
| `draft_generation` | `0.3` | `0.9` | `0.1` | Professional, empathetic tone |
| `thread_summarization` | `0.1` | `1.0` | `0.0` | Strictly factual summary |
| `critic_scoring` | `0.0` | `1.0` | `0.0` | Unbiased evaluation |

---

## Related Files
- [models.md](models.md)
