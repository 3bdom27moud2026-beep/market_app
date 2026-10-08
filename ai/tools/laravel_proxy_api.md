# Tool Specification: Laravel Proxy API (`laravel_proxy_api`)

## Overview
Specification for the proxy interface connecting the dedicated Customer Support AI Microservice with the Laravel Backend API (`https://backendapp.weoryx.com/api`).

---

## 1. Endpoint & Authentication

- **Base URL**: `https://backendapp.weoryx.com/api`
- **Authentication**: Bearer Token via HTTP Header (`Authorization: Bearer <token>`)
- **Content-Type**: `application/json`

---

## 2. Supported Routes

| Route Name | HTTP Method | Path | Description |
| :--- | :--- | :--- | :--- |
| `get_all_chats` | GET | `/chats?type={all\|mine\|unassigned}&unreply={0\|1}` | Fetch chat thread list |
| `get_messages` | GET | `/chat-messages/{chatId}?page={page}` | Fetch message history for a chat |
| `send_message` | POST | `/send-message` | Send text or attachment message |
| `get_profile` | GET | `/user` | Fetch agent profile |

---

## 3. Request Schema
Requests conform to standard HTTP query parameters or JSON body payloads.

---

## 4. Response Normalization Rules
The proxy normalizes varied backend response shapes:
- Unwraps root keys: `response['chats']`, `response['messages']`, `response['data']`.
- Ensures array results are wrapped as clean JSON lists.

---

## 5. Error Codes & Retries
- **Rate Limits**: 100 requests / minute.
- **Timeout**: 5000ms.
- **Retry Strategy**: Up to 3 retries with 1000ms exponential backoff for `504 Timeout` and `429 Rate Limit`.

---

## 6. Deprecation Policy
- Current Version: `v1` (Active).

---

## Related Files
- [chat_messages_api.md](chat_messages_api.md)
- [send_message_api.md](send_message_api.md)
- [../shared/error_codes.md](../shared/error_codes.md)
