# Booking Policies & Rules Knowledge Base

## Overview
Static knowledge about cancellation policies, refund rules, booking confirmation flows, and payment terms used across the booking domain.

---

## Standard Cancellation Policy Tiers

| Policy Tier | Cancellation Deadline | Refund |
| :--- | :--- | :--- |
| Flexible | Up to 24h before | 100% refund |
| Moderate | Up to 5 days before | 50% refund |
| Strict | Up to 14 days before | No refund |
| Non-refundable | Any time | No refund |

---

## Booking Confirmation Rules
- A booking is **confirmed** only when `payment_status = "paid"` and `status = "confirmed"`.
- Never communicate a booking as confirmed before payment succeeds.
- Always present `booking_id` in the confirmation response.
- Cancellation requests must be verified against the policy tier before processing.

---

## Payment Terms
- Accepted currencies: see [currencies.md](currencies.md).
- Tax is always presented separately from base price.
- 3D Secure authentication is required for all card payments above USD 100.

---

## Related Files
- [../schemas/booking.json](../schemas/booking.json)
- [../skills/booking/create_booking.md](../skills/booking/create_booking.md)
- [../domains/bookings/bookings_domain.md](../domains/bookings/bookings_domain.md)
