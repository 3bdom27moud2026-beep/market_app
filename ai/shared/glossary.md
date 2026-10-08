# Domain Glossary

## 1. Overview
Central terminology and definition reference for the Customer Support & Inbox Management AI Platform.

## 2. Purpose
Eliminates ambiguity by defining exact domain terms used across Flutter models, Laravel APIs, and AI agent logic.

## 3. Responsibilities
- Provide clear definitions for all core concepts in the customer support domain.

## 4. Inputs
None.

## 5. Outputs
Reference terminology used in all specifications.

## 6. Dependencies
None.

## 7. Related Files
- [constants.md](constants.md)
- [conventions.md](conventions.md)
- [../README.md](../README.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Key Terminology

| Term | Definition |
| :--- | :--- |
| **AllChatsEntite** | The primary Flutter domain entity representing a single customer conversation thread. |
| **MessageEntity** | Flutter entity representing an individual text, media, or audio message inside a chat thread. |
| **ai_session_id** | Unique session identifier linking AI conversation memory to a specific support thread lifecycle. |
| **Draft Suggestion** | An AI-generated response proposal shown to a human agent in the mobile chat screen for review. |
| **Autonomous Reply** | An AI response automatically dispatched directly to WhatsApp/Messenger without agent intervention. |
| **Escalation** | The process of transferring conversation control from AI to a human support agent due to low confidence or customer frustration. |
| **Unreplay / Unreplied** | Filter state indicating a chat thread containing pending customer messages that haven't received a response. |
| **Channel** | Communication platform connection (e.g. WhatsApp Business API or Facebook Messenger Page). |
| **Customer** | End-user initiating support inquiries via a messaging channel. |

## 10. Edge Cases
None.

## 11. Error Handling
None.

## 12. Extension Points
- Terms added as new channels or capabilities are introduced.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- Flutter app domain entity definitions (`lib/features/home/domain/entites/`).
