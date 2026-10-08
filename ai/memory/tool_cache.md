# Tool Results Cache (`tool_cache`)

## 1. Overview
Defines in-memory caching for backend tool execution results within an active session.

## 2. Purpose
Prevents duplicate API calls to backend endpoints during multi-turn conversations.

## 3. Responsibilities
- Cache tool responses (`crm_customer_api`, `chat_messages_api`) for 300 seconds.
- Invalidate cache when state-changing actions occur (`close_chat`, `change_status`).

## 4. Inputs
- `schemas/tool_result.json` payloads.

## 5. Outputs
- Cached tool result payloads.

## 6. Dependencies
- `tools/registry.md`

## 7. Related Files
- [working_memory.md](working_memory.md)
- [../tools/registry.md](../tools/registry.md)
