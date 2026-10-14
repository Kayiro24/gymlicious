# Quote providers

Checked 2026-10-14 against spec Section 6.2 (key-less only, terms must allow on-device storage in a commercial app, attribution noted). Re-check before each release, since terms change.

## In v1

| Source | Status | Limits | Storage / commercial terms | Attribution |
|--------|--------|--------|----------------------------|-------------|
| Bundled set (`assets/quotes/bundled_quotes.json`) | **Used** | n/a | Original lines (spec Appendix A) | None |
| AnimeChan (`https://api.animechan.io/v1/quotes/random`) | **Used** | Docs: 100 requests/day per IP, anonymous. The spec assumes 5/hour; our budget of **3/hour** (72/day max) fits under both. | Terms §5: "You may use the data provided by our API in your applications, but you may not claim ownership of the data itself." Storage is not prohibited. Quotes remain "the intellectual property of their respective owners." | Terms §4: "Properly attribute Animechan as the source of data." The card shows *Character, Anime*; About credits AnimeChan. |

AnimeChan response shape: `{"status": "success", "data": {"content", "anime": {"id", "name", "altName"}, "character": {"id", "name"}}}`.

## Evaluated for the "motivation" slot and rejected

| Candidate | Why not |
|-----------|---------|
| ZenQuotes (`zenquotes.io/api/quotes`) | Key-less, 5 requests/30 s, requires an attribution link. Its terms (`docs.zenquotes.io/terms-and-conditions/`) limit material to "personal, non-commercial use". That fails rule 2 for a store app. |
| Quotable (`api.quotable.io`) | MIT code and a 180/min limit, but the API did not respond (connection timed out) on 2026-10-14. That fails the uptime check. |
| DummyJSON quotes (`dummyjson.com/quotes`) | Up and key-less, but it is a mock-data service for testing, and the content is general, not fitness (one sample was about cyclones in the Bay of Bengal). |

**Result:** v1 ships without a second online source. Mix mode = bundled + AnimeChan. The `QuoteSource` registry makes adding one a single adapter plus one registration once a provider passes these checks.
