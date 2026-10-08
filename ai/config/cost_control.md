# Cost Controls & Budget Caps (`cost_control`)

## Overview
Budget caps, rate limits, and fallback controls preventing unexpected cloud API charges.

---

## Cost Controls

| Control Type | Threshold | Trigger Action |
| :--- | :--- | :--- |
| **Daily Spend Limit** | $50.00 / day | Alert admin & fallback to Flash models |
| **Monthly Budget** | $1,000.00 / month | Enforce strict draft-only mode |
| **Per-Conversation Max** | $0.15 / chat | Mute AI for remainder of session |

---

## Related Files
- [token_limits.md](token_limits.md)
- [../observability/metrics.md](../observability/metrics.md)
