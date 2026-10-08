# Chats Domain Business Logic Specification

## 1. Overview
The Chats Domain defines business rules, filtering states (`type`, `unreplay`, `readStatus`), pagination logic, and entity validation for customer support conversation threads.

## 2. Purpose
Aligns the AI Microservice with the Flutter `AllChatsEntite` model and Laravel backend `/chats` API endpoints.

## 3. Responsibilities
- Enforce chat thread filtering taxonomy (`mine`, `unassigned`, `all`).
- Validate `unreplay` flags (`1` = unreplied customer messages present, `0` = replied).
- Bind `ai_session_id` to thread lifecycle events.

## 4. Inputs
- Flutter `AllChatsEntite` objects and `/chats` query parameters.

## 5. Outputs
- Validated chat thread state payloads (`schemas/chat_thread.json`).

## 6. Dependencies
- `schemas/chat_thread.json`
- `tools/laravel_proxy_api.md`

## 7. Related Files
- [../messages/messages_domain.md](../messages/messages_domain.md)
- [../../schemas/chat_thread.json](../../schemas/chat_thread.json)
- [../../tools/laravel_proxy_api.md](../../tools/laravel_proxy_api.md)

## 8. Sequence Diagram / Workflow

```mermaid
flowchart TD
    FetchChats[Flutter App Requests /chats] --> ApplyFilter[Filter by type: mine | unassigned | all]
    ApplyFilter --> ApplyUnreplay[Filter by unreplay: 1 | 0]
    ApplyUnreplay --> AttachSession[Attach active ai_session_id]
    AttachSession --> ReturnThreads[Return AllChatsEntite List]
```

## 9. Examples

### Chat Filter Taxonomy Table

| Filter Type (`type`) | `unreplay` | Description | Target User |
| :--- | :--- | :--- | :--- |
| `mine` | `0` | Active chats assigned to current agent | Support Agent |
| `unassigned` | `1` | Pending chats awaiting human assignment | Support Queue |
| `all` | `0` or `1` | Complete organization inbox | Team Manager |

## 10. Edge Cases
- Missing `ai_session_id` in `/chats` response: System automatically generates a deterministic session UUID based on `chat_id` and `customer_id`.

## 11. Error Handling
- Invalid filter parameters raise `VALIDATION_INVALID_FILTER` error.

## 12. Extension Points
- Customer SLA tier badges (e.g. VIP tag).

## 13. API & Schema Versioning
- Version: 2.0.0

## 14. References
- Flutter model: `lib/features/home/domain/entites/all_chats_entites.dart`
