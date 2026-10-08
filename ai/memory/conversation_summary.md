# Conversation Summary Buffer (`conversation_summary`)

## 1. Overview
Defines condensed thread summaries generated when working memory exceeds 10 turns.

## 2. Purpose
Prevents context token window overflow while retaining historical conversation facts.

## 3. Responsibilities
- Store condensed topic summary of turns 1–20.
- Append verbatim working memory for turns 21–30.

## 4. Inputs
- `schemas/thread_summary.json` payload.

## 5. Outputs
- Compacted memory buffer string.

## 6. Dependencies
- `memory/working_memory.md`
- `skills/support/summarize_thread.md`

## 7. Related Files
- [working_memory.md](working_memory.md)
- [customer_profile.md](customer_profile.md)
