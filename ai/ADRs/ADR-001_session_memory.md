# ADR-001: Session-Scoped Memory Isolation (`ai_session_id`)

## 1. Title
ADR-001: Session-Scoped Memory Isolation (`ai_session_id`)

## 2. Status
Accepted

## 3. Date
2026-08-04

## 4. Context
Customer support threads require conversational memory so the AI understands earlier context in a thread. However, retaining permanent cross-session memory across unrelated support issues introduces privacy risks, context bloat, and hallucination risks.

## 5. Decision
We bind all working AI conversation memory strictly to a session identifier (`ai_session_id`). Memory buffers are created when a support session begins and purged or archived when the thread is closed or escalated.

## 6. Alternatives Evaluated
- **Permanent Customer Vector Memory**: High cost, high PII leak risk, prone to injecting outdated context from past years.
- **Stateless Zero-Memory Processing**: Low cost, but forces customers to repeat information across multiple turns.

## 7. Consequences
- **Positive**: Zero cross-session PII leakage, deterministic memory bounds (max 30 turns), reduced token cost.
- **Negative**: Customers opening a new session must state their context fresh.

## 8. Related Files
- [../brain/memory.md](../brain/memory.md)
- [../memory/working_memory.md](../memory/working_memory.md)
- [../ARCHITECTURE_DECISIONS.md](../ARCHITECTURE_DECISIONS.md)

## 9. References
- Session state management standards.
