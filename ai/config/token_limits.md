# Token Allocation Caps (`token_limits`)

## Overview
Defines maximum prompt and completion token caps per API endpoint to control latency and prevent excessive spending.

---

## Token Allocation Matrix

| Endpoint | Max Prompt Tokens | Max Completion Tokens | Total Max Window |
| :--- | :--- | :--- | :--- |
| `/generate-draft` | 2,000 | 350 | 2,350 |
| `/auto-reply` | 1,500 | 250 | 1,750 |
| `/summarize` | 4,000 | 300 | 4,300 |
| `/classify` | 500 | 100 | 600 |

---

## Related Files
- [cost_control.md](cost_control.md)
- [models.md](models.md)
