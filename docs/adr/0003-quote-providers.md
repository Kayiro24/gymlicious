# ADR 0003: Quote providers

Status: accepted (2026-10-14)

## Context
Spec 6 wants a motivational quote on Home with no backend: a bundled set plus key-less online APIs called from the device. Sources must allow on-device storage in a commercial app and need attribution handled. Findings are in `docs/quote-providers.md`.

## Decision
- **Bundled set** of 24 original lines always works offline.
- **AnimeChan** is the only online source in v1 (D35). It is called directly over HTTPS with a 5 s timeout, no cookies and no user data.
- A `QuoteSource` interface per provider, registered in a list, so adding a provider is one adapter plus one registration.
- `RateBudget` allows 3 AnimeChan requests per rolling hour and one background refresh per day, with a 1-hour back-off after a 429 or 3 errors (D36).
- `QuoteCache` keeps at most 100 quotes for 30 days. `QuoteQueue` avoids repeating any of the last 5. The cache is excluded from OS backup.
- Modes: `gym`, `anime`, `mix` (default), `off` (D34). Online fetching can be disabled with the `ONLINE_QUOTES_ENABLED` config flag.

## Consequences
- Home never waits on the network; the bundled set covers first launch and offline use.
- Providers see the device IP address; the privacy policy says so.
- Anime dialogue is third-party IP; the card always shows character and anime, and About credits AnimeChan.
