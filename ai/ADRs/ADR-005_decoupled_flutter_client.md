# ADR-005: Decoupled Mobile Client Architecture

## 1. Title
ADR-005: Decoupled Mobile Client Architecture

## 2. Status
Accepted

## 3. Date
2026-08-04

## 4. Context
Embedding AI prompts or LLM logic into the Flutter mobile app makes updating AI behavior require a full App Store / Play Store release cycle.

## 5. Decision
The Flutter mobile application remains a pure UI client consuming standardized JSON contracts (`schemas/chat_message.json`, `schemas/draft_suggestion.json`, `schemas/thread_summary.json`). All prompt engineering, RAG logic, and AI routing live entirely on the backend AI Runtime.

## 6. Alternatives Evaluated
- Embedded Prompts in Flutter: Rigid, requires app updates for minor prompt tweaks.

## 7. Consequences
- **Positive**: Instant prompt and model updates without mobile app releases; clean separation of concerns.
- **Negative**: Client depends entirely on JSON schema version stability.

## 8. Related Files
- [../schemas/chat_message.json](../schemas/chat_message.json)
- [../sdk/ai_runtime_api.md](../sdk/ai_runtime_api.md)
- [../ARCHITECTURE_DECISIONS.md](../ARCHITECTURE_DECISIONS.md)

## 9. References
- Decoupled Mobile Client Architecture.
