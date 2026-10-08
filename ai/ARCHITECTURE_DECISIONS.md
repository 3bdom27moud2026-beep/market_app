# Architecture Decision Records (ADRs)

## Overview
This index lists all Architecture Decision Records (ADRs) for the Customer Support AI Runtime. Each ADR documents a critical architectural decision, its context, evaluated alternatives, and consequences.

---

## ADR Index

| ADR ID | Title | Status | Date | Decision Summary |
| :--- | :--- | :--- | :--- | :--- |
| [ADR-001](ADRs/ADR-001_session_memory.md) | Session-Scoped Memory Isolation (`ai_session_id`) | Accepted | 2026-08-04 | Bind AI conversation memory strictly to `ai_session_id` lifecycle. |
| [ADR-002](ADRs/ADR-002_hybrid_ai_model.md) | Hybrid AI Copilot & Autonomous Handling | Accepted | 2026-08-04 | Combine auto-replies for low-risk intents with draft suggestions & human escalation. |
| [ADR-003](ADRs/ADR-003_laravel_proxy.md) | Proxying AI Integration via Laravel Backend | Accepted | 2026-08-04 | All AI interactions route through Laravel backend API rather than directly from mobile client. |
| [ADR-004](ADRs/ADR-004_multi_provider_routing.md) | Multi-Provider Dynamic Model Routing | Accepted | 2026-08-04 | Route tasks across OpenAI, Google Gemini, and Anthropic based on cost and latency caps. |
| [ADR-005](ADRs/ADR-005_decoupled_flutter_client.md) | Decoupled Mobile Client Architecture | Accepted | 2026-08-04 | Keep Flutter app pure UI client consuming standardized JSON contracts without embedded LLM logic. |

---

## Related Files
- [README.md](README.md)
- [MANIFEST.json](MANIFEST.json)
- [DOCUMENTATION_GUIDELINES.md](DOCUMENTATION_GUIDELINES.md)
