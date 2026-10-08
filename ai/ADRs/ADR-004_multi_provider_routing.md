# ADR-004: Multi-Provider Dynamic Model Routing

## 1. Title
ADR-004: Multi-Provider Dynamic Model Routing

## 2. Status
Accepted

## 3. Date
2026-08-04

## 4. Context
Relying on a single LLM provider creates vendor lock-in, exposes the platform to provider outages, and prevents cost optimization across different task complexities.

## 5. Decision
Implement dynamic multi-provider routing across OpenAI, Google Gemini, and Anthropic. Fast/cheaper models (e.g. Gemini 1.5 Flash / GPT-4o-mini) handle intent classification and RAG ranking, while reasoning models (e.g. Claude 3.5 Sonnet / GPT-4o) handle complex draft generation and summarization.

## 6. Alternatives Evaluated
- Single Provider (OpenAI Only): High cost, vulnerability to rate limits and outages.
- Local Self-Hosted Llama Models: High infrastructure overhead and GPU costs.

## 7. Consequences
- **Positive**: ~40% cost reduction, 99.99% availability via instant failover.
- **Negative**: Requires multi-provider SDK abstractions.

## 8. Related Files
- [../config/providers.md](../config/providers.md)
- [../config/models.md](../config/models.md)
- [../ARCHITECTURE_DECISIONS.md](../ARCHITECTURE_DECISIONS.md)

## 9. References
- LLM Multi-Provider Routing Patterns.
