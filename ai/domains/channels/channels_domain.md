# Channels Domain Business Logic Specification

## 1. Overview
The Channels Domain manages channel metadata, platform types (WhatsApp, Facebook Messenger), phone number accounts, and channel-specific formatting constraints.

## 2. Purpose
Maps channel configurations to AI response formatting and channel policy rules.

## 3. Responsibilities
- Identify channel platform (`WhatsApp`, `Messenger`).
- Adapt Markdown formatting to channel syntax (e.g. WhatsApp bold `*` vs Markdown `**`).
- Enforce channel-specific message length rules.

## 4. Inputs
- `Channel` entity payload (`id`, `platform_id`, `whatsapp_phone_numbers`).

## 5. Outputs
- Channel-adapted response payloads.

## 6. Dependencies
- `brain/response_rules.md`

## 7. Related Files
- [../chats/chats_domain.md](../chats/chats_domain.md)
- [../../brain/response_rules.md](../../brain/response_rules.md)

## 8. Sequence Diagram / Workflow
Not applicable.

## 9. Examples

### Channel Specs Table

| Platform | Channel ID | Max Message Length | Syntax Rules |
| :--- | :--- | :--- | :--- |
| **WhatsApp** | `platform_id = 1` | 4,096 chars | `*bold*`, `_italic_`, `~strike~` |
| **Messenger** | `platform_id = 2` | 2,000 chars | Markdown supported |

## 10. Edge Cases
- Unrecognized channel platform: Defaults to standard plain text with all markdown stripped.

## 11. Error Handling
- Channel lookup failures raise `CHANNEL_NOT_FOUND` error.

## 12. Extension Points
- Telegram & Instagram Direct Message channel bindings.

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- Flutter entity: `lib/features/home/domain/entites/sub_entites/channel.dart`
