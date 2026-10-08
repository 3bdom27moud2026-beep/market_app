# User Preference Memory & Long-Term Vector Profile

## 1. Overview
Long-term preference store indexing user travel style, dietary restrictions, preferred airlines, budget ranges, and explicit user feedback.

## 2. Purpose
Personalizes AI recommendations over time across multiple sessions.

## 3. Responsibilities
- Store structured user profile preferences.
- Perform semantic vector similarity search against past travel preferences.

## 4. Inputs
User ID & explicit preference updates.

## 5. Outputs
Personalization context vector.

## 6. Dependencies
- [user.json](file:///c:/Users/bss/studio%20projects/chat_app/ai/schemas/user.json)

## 7. Related Files
- [recommendations.md](file:///c:/Users/bss/studio%20projects/chat_app/ai/skills/travel/recommendations.md)
- [profile.md](file:///c:/Users/bss/studio%20projects/chat_app/ai/skills/account/profile.md)

## 8. Sequence Diagram / Workflow
```mermaid
flowchart LR
    Coordinator[Coordinator Agent] --> UserMemory[ai/memory/user_memory.md]
    UserMemory --> PersonalizationVector[Personalization Context Injection]
```

## 9. Examples
```json
{
  "user_id": "user_49102",
  "travel_profile": {
    "preferred_seat": "window",
    "dietary_restrictions": ["vegetarian"],
    "loyalty_programs": ["Marriott Bonvoy"],
    "typical_budget_tier": "luxury"
  }
}
```

## 10. Edge Cases
Users can request complete erasure of user memory in accordance with GDPR right-to-be-forgotten.

## 11. Error Handling
Missing profile data defaults to neutral global travel preferences.

## 12. Extension Points
Integrate Vector DB (Pinecone / Qdrant) backend.

## 13. API & Schema Versioning
Memory Spec: 2.0.0

## 14. References
- GDPR Compliance Directives.
