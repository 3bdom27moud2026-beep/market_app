# ADR-003: Proxying AI Integration via Laravel Backend

## 1. Title
ADR-003: Proxying AI Integration via Laravel Backend

## 2. Status
Accepted

## 3. Date
2026-08-04

## 4. Context
Connecting the Flutter mobile application directly to AI inference APIs exposes API keys, prevents centralized rate limiting, and makes audit logging impossible.

## 5. Decision
All AI runtime operations route exclusively through the Laravel backend API (`https://backendapp.weoryx.com/api`). The Laravel backend proxies requests to the dedicated AI Runtime, enforcing authentication, permissions, and audit logs.

## 6. Alternatives Evaluated
- Direct Flutter -> LLM Calls: Insecure, exposes secret keys in client APK.
- Client-side On-Device LLM: Limited model accuracy and mobile memory constraints.

## 7. Consequences
- **Positive**: Complete security, centralized rate limiting, seamless key rotation, audit trails.
- **Negative**: Adds single hop latency (~15ms).

## 8. Related Files
- [../tools/laravel_proxy_api.md](../tools/laravel_proxy_api.md)
- [../sdk/ai_runtime_api.md](../sdk/ai_runtime_api.md)
- [../ARCHITECTURE_DECISIONS.md](../ARCHITECTURE_DECISIONS.md)

## 9. References
- Enterprise API Gateway Security Patterns.
