# Escalation Evaluation Prompt Template

## Purpose
Prompt template used to evaluate whether a customer support thread requires human escalation due to sentiment degradation or low confidence.

## Template

```markdown
Evaluate if the customer support thread requires human agent takeover.

## Message History
{{conversation_history}}

## Intent & Confidence Context
Intent: {{intent}}
Confidence: {{confidence}}

## Criteria for Escalation
1. Negative sentiment score < -0.50.
2. Low confidence score < 0.60.
3. Explicit customer request for human agent ("speak to a human", "manager").
4. High-risk intent (billing dispute, legal threat, cancellation).

## Guidelines
- Output strictly valid JSON matching `schemas/escalation_event.json`.
```

## Related Files
- [../brain/confidence.md](../brain/confidence.md)
- [../schemas/escalation_event.json](../schemas/escalation_event.json)
- [../skills/support/detect_escalation.md](../skills/support/detect_escalation.md)
