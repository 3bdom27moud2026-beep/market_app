# Machine-Readable Tool & Action Registry

## Overview
Central machine-readable registry documenting all tools, actions, and API wrappers available for invocation by the Planner Agent and Executor Agent.

---

## Tool Directory

| Tool Name | Type | Description | Input Schema | Permission Role | Timeout (ms) | Retry Limit |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `assign_agent` | Action | Assign chat thread to human agent | `schemas/action_payload.json` | `agent_write` | 3000 | 2 |
| `close_chat` | Action | Mark chat thread as resolved/closed | `schemas/action_payload.json` | `agent_write` | 3000 | 2 |
| `change_status` | Action | Change ticket priority or read status | `schemas/action_payload.json` | `agent_write` | 3000 | 2 |
| `add_tag` | Action | Add intent or urgency tag to chat | `schemas/action_payload.json` | `agent_write` | 3000 | 2 |
| `create_ticket` | Action | Create CRM support ticket | `schemas/action_payload.json` | `agent_write` | 5000 | 3 |
| `send_template` | Action | Dispatch pre-approved WhatsApp template | `schemas/action_payload.json` | `bot_send` | 5000 | 3 |
| `search_customer` | Action | Search customer profile by phone/email | `schemas/action_payload.json` | `crm_read` | 3000 | 2 |
| `update_customer` | Action | Update customer profile metadata | `schemas/action_payload.json` | `crm_write` | 4000 | 2 |
| `create_note` | Action | Add internal agent note to thread | `schemas/action_payload.json` | `agent_write` | 3000 | 2 |
| `laravel_proxy` | API Proxy | General Laravel proxy client | `schemas/tool_call.json` | `system` | 5000 | 3 |

---

## Related Files
- [actions/assign_agent.md](actions/assign_agent.md)
- [actions/close_chat.md](actions/close_chat.md)
- [laravel_proxy_api.md](laravel_proxy_api.md)
- [../agents/planner.md](../agents/planner.md)
