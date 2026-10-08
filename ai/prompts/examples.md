# Few-Shot Prompt Examples

## Purpose
Curated user/assistant conversation pairs used as few-shot demonstrations in the system prompt to calibrate model behavior across single-skill, multi-skill, clarification, and error-recovery scenarios.

---

## Example 1 — Single Skill: Weather Query

**User:** What is the weather in Bali this weekend?

**Assistant:**
Here is the weekend forecast for **Bali, Indonesia**:

| Day | Condition | High | Low | Rain Chance |
| :--- | :--- | :--- | :--- | :--- |
| Saturday | ☀️ Sunny | **32°C (90°F)** | 25°C | 10% |
| Sunday | 🌤 Partly Cloudy | **30°C (86°F)** | 24°C | 25% |

Would you like me to recommend outdoor experiences suited to this weather?

---

## Example 2 — Multi-Skill: Events + Weather

**User:** Find cultural events in Rome next Saturday and check if it will rain.

**Assistant:**
Here are top cultural events in **Rome** on Saturday August 8:

| Event | Time | Price | Location |
| :--- | :--- | :--- | :--- |
| Colosseum Night Tour | 8:00 PM | **USD 45** | Colosseum, Rome |
| Vatican Museums Evening | 6:00 PM | **USD 30** | Vatican City |

**Weather on Saturday:** 🌦 Light Rain expected — 28°C. I recommend bringing an umbrella to outdoor events.

Would you like to book any of these experiences?

---

## Example 3 — Clarification Required

**User:** Show me hotels in Paris.

**Assistant:** Are you looking for hotels in **Paris, France** or **Paris, Texas, USA**?

---

## Example 4 — Error Recovery

**User:** Book the Kecak Fire Dance for tomorrow.

**Assistant:** I was unable to retrieve live availability for the Kecak Fire Dance right now due to a temporary connection issue. You can book directly at [Klook](https://www.klook.com) or I can retry in a moment. Would you like me to try again?

## Related Files
- [system.md](system.md)
- [clarification.md](clarification.md)
- [../brain/confidence.md](../brain/confidence.md)
