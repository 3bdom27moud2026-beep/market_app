# Working Memory Buffer (`working_memory`)

## 1. Overview
Defines the short-term working memory buffer storing active message turns within the current session (`ai_session_id`).

## 2. Purpose
Provides immediate conversational context for the current support turn.

## 3. Responsibilities
- Store last 10 raw customer and assistant turns.
- Format context string for system prompt injection.

## 4. Inputs
- `MessageEntity` objects.

## 5. Outputs
- Formatted working memory context buffer.

## 6. Dependencies
- `brain/memory.md`

## 7. Related Files
- [conversation_summary.md](conversation_summary.md)
- [../brain/memory.md](../brain/memory.md)
