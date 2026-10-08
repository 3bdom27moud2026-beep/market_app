# ADR-002: Hybrid AI Copilot & Autonomous Handling

## 1. Title
ADR-002: Hybrid AI Copilot & Autonomous Handling

## 2. Status
Accepted

## 3. Date
2026-08-04

## 4. Context
Full autonomous AI response dispatching carries risk of hallucination or brand damage during complex customer issues. Conversely, pure manual agent drafting provides zero automation for standard repetitive inquiries.

## 5. Decision
Implement a hybrid decision engine:
- High confidence (>= 0.85) & Low Risk -> Autonomous Auto-Reply.
- Medium confidence (0.60–0.84) or Medium Risk -> Draft Suggestion to agent UI.
- Low confidence (< 0.60) or High Risk / Frustration -> Human Escalation.

## 6. Alternatives Evaluated
- 100% Autonomous Bot: High risk of customer dissatisfaction.
- 100% Agent Co-pilot Only: High agent workload for trivial FAQs.

## 7. Consequences
- **Positive**: Maximizes automation for FAQs while eliminating risk on sensitive issues.
- **Negative**: Requires confidence scoring calibration tuning.

## 8. Related Files
- [../brain/decision_engine.md](../brain/decision_engine.md)
- [../brain/confidence.md](../brain/confidence.md)
- [../ARCHITECTURE_DECISIONS.md](../ARCHITECTURE_DECISIONS.md)

## 9. References
- Customer support AI hybrid patterns.
