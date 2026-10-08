# Response Formatting & Quality Rules

## 1. Overview
Defines output formatting, length limits, structural rules, and channel constraints for all AI-generated support messages.

## 2. Purpose
Ensures responses are optimized for mobile chat screens (WhatsApp, Messenger) and conform to support UX standards.

## 3. Responsibilities
- Enforce length limits (max 300 words for mobile messages).
- Format lists, dates, and order numbers consistently.
- Prevent robotic intros and repetitive filler.

## 4. Inputs
Candidate response text.

## 5. Outputs
Formatted response text.

## 6. Dependencies
- `brain/personality.md`
- `shared/conventions.md`

## 7. Related Files
- [personality.md](personality.md)
- [safety.md](safety.md)
- [../prompts/system.md](../prompts/system.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Formatting Rules Table

| Rule | Requirement | Example |
| :--- | :--- | :--- |
| **Max Length** | Under 300 words | Concise bullet points |
| **Price / Currency** | Always specify ISO currency | `USD 49.99` or `EGP 250.00` |
| **Dates** | Use readable format | `August 10, 2026 at 3:00 PM` |
| **Order ID** | Bold order numbers | **#58210** |
| **Paragraphs** | Max 3 sentences per paragraph | Clean spacing for mobile |

## 10. Edge Cases
- WhatsApp formatting: Converts markdown bold `**` to WhatsApp bold `*` when sending over WhatsApp channel.

## 11. Error Handling
- Overlength responses are automatically truncated with a "Read more" link or split into two messages.

## 12. Extension Points
- Channel-specific syntax transformers (HTML vs Markdown vs WhatsApp syntax).

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- `shared/conventions.md`
