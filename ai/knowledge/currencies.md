# Currency Reference & Formatting Rules

## Overview
ISO 4217 currency codes, formatting conventions, and display rules for all monetary values in the AI platform.

---

## Currency Reference (Selected)

| Currency | ISO 4217 Code | Symbol | Decimal Places | Example |
| :--- | :--- | :--- | :--- | :--- |
| US Dollar | USD | $ | 2 | $120.00 |
| Euro | EUR | € | 2 | €95.00 |
| British Pound | GBP | £ | 2 | £80.00 |
| Indonesian Rupiah | IDR | Rp | 0 | Rp 1,800,000 |
| UAE Dirham | AED | AED | 2 | AED 440.00 |
| Japanese Yen | JPY | ¥ | 0 | ¥13,200 |
| Thai Baht | THB | ฿ | 2 | ฿3,500.00 |

---

## Formatting Rules
- Always display the ISO code alongside the symbol: **USD 120.00**, not just **$120.00**.
- Use locale-appropriate decimal separators (`.` for US; `,` for EU).
- Round to the nearest unit for zero-decimal currencies (IDR, JPY).
- Never display raw numbers without currency annotation.

---

## Related Files
- [countries.md](countries.md)
- [../schemas/booking.json](../schemas/booking.json)
