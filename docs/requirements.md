# Gym Tracker App: Requirements & Build Spec

> **Audience:** Claude Code (AI coding agent). Read this entire file before writing any code.
> **Deliverable:** one Flutter app (Android + iOS, one codebase). **There is no backend in v1.** Quotes are bundled in the app and, when online, fetched directly from public quote APIs (Section 6).
> **Relationship to the Gym SaaS spec:** This is a **separate product** for individual lifters. It shares nothing with the gym-management SaaS except the modular UI + responsiveness principles.

> Resolved questions and deviations: see `docs/decisions.md` (it takes precedence where it explicitly amends this file).

---

## 0. Instructions for Claude Code (read first)

1. **Plan first.** Write `docs/plan.md` (repo layout, pinned packages with a one-line reason each, risks and ambiguities found in this spec) and wait for approval before writing feature code.
2. Build order: **local data layer + first-launch gate → workout features → backup/restore → Year Dots → quotes → polish.** The app must be fully usable offline.
3. **No user data ever leaves the device.** No accounts, no analytics SDKs, no crash reporters that upload user data, no cloud sync. The app's only network calls are the public quote APIs in Section 6, and they receive no user data.
4. Every feature ships with tests (Section 11). Backup → wipe → restore round-trip is the most important test in the project.
5. Ask before inventing. Check Section 13 (decisions already made) first; if still unclear, choose the simplest option and log it in `docs/decisions.md`.
6. **UI follows the modular pattern and is responsive everywhere** (Section 8). Soft minimalism visual style (Section 7). Do not write one-off screens or hard-coded styles.
7. **Write professional, scalable code per Section 10A:** clean layered architecture, dependency injection, typed errors, strict lints, and **minimal comments** (only a one- or two-line "why" when something is non-obvious; no narration, banners, or commented-out code). Prefer clear names over comments. Do not over-engineer: abstract only at the seams listed in 10A.

---

## 1. Product Overview

A private, offline-first workout tracker. The user opens the app, enters a few personal details once, and then logs workouts by **split** (e.g. Push/Pull/Legs), tracking per exercise the **last weight** and the **maximum weight** they have lifted. Everything is stored in a file on the user's own device. A motivational quote (gym or anime) is shown on the home screen.

### Principles
| # | Principle |
|---|-----------|
| 1 | **No sign-up, no login.** A mandatory first-launch details gate replaces it. |
| 2 | **Offline-first.** Every feature except fetching new quotes works with no internet. |
| 3 | **Local-only data.** Stored in a file on the device. The user owns it via manual backup/restore. |
| 4 | **Fast logging.** Logging a set should take one or two taps (prefilled from last time). |
| 5 | **Calm UI.** Soft minimalism: quiet, spacious, rounded, unhurried. |

### Platforms
Android (minSdk 23+) and iOS (14+), phones and tablets, portrait and landscape.

---

## 2. Tech Stack & Repository Layout

| Layer | Choice |
|-------|--------|
| App | Flutter (latest stable), Dart null-safe |
| State | Riverpod |
| Navigation | go_router |
| Models | freezed + json_serializable |
| Local storage | JSON file via `path_provider` (see 4.1) behind a repository interface |
| HTTP | dio (timeouts, retry-light) |
| Charts | fl_chart |
| Native wallpaper / intents | Kotlin `WallpaperService` (Android live wallpaper, Section 5.10), optional Swift App Intent (iOS Shortcuts), via platform channels |
| Sharing / files | share_plus, file_picker, a SAF/Files-app save helper (`file_saver` or equivalent) |
| Images | image_picker + a crop/resize step |
| Hashing | crypto (SHA-256) |
| Quote sources | Key-less public quote APIs called directly through `dio`, plus a bundled fallback set (Section 6) |

> Pin exact package versions at scaffold time and record them in `docs/dependencies.md`. Verify each package supports the latest Android and iOS targets before committing to it.

```
gym-tracker/
├── design-tokens/        # tokens.json (soft minimalism) -> generated Dart theme
├── mobile/               # Flutter app
│   ├── assets/           # seed exercises, preset splits, offline quotes, bundled fonts
│   └── lib/
│       ├── core/         # theme, storage, network, router, l10n, utils
│       ├── design_system/# primitive widgets
│       ├── shared/       # composite widgets
│       └── features/     # onboarding, home, train, exercises, history, year_dots, profile, settings, backup, quotes
│   ├── android/          # includes the Kotlin live wallpaper service
│   └── ios/              # includes the optional Swift App Intent
└── docs/
```

---

## 3. Project Conventions

There is no backend in v1, so there are no server conventions to mirror. All code conventions are in Section 10A. If a backend is added later (Section 6.4), it plugs in behind the `QuoteSource` interface.

---

## 4. Data on the Device

### 4.1 Storage design
- **Primary file:** `gymtracker_data.json` in the app's private documents directory (`path_provider`).
- **Profile photo:** stored separately as `profile_photo.jpg` (do not inline base64 in the primary file). Resized to max 512px, JPEG quality ~80, square crop.
- **Quote cache:** `quotes_cache.json`, **not** part of backups.
- **Atomic writes:** write to `gymtracker_data.json.tmp`, flush, copy current file to `gymtracker_data.json.bak`, then rename the temp file over the primary. A crash mid-write must never destroy the user's data.
- **Single writer:** all writes go through one serialized queue; debounce saves (~500 ms) but flush immediately on app pause/background.
- **Corruption recovery:** if the primary file fails to parse or validate, try `.bak`; if that fails too, show a recovery screen offering **Restore from backup** or **Start fresh** (with a clear warning).
- **Load/parse in an isolate** (`compute`) so large histories don't block the first frame.
- **Repository interface:** the app talks to `DataRepository` (profile, splits, exercises, sessions, settings), never to the file directly. This keeps a later move to SQLite (e.g. Drift) cheap if histories outgrow a JSON file (rough threshold: several MB).
- **Schema versioning:** `schemaVersion` integer at the root with ordered migration functions. Never ship a breaking schema change without a migration and a test.

### 4.2 Units
- Store **weights in kg** and **height in cm** (canonical). Convert for display using the user's unit setting. Round displayed values sensibly (trim trailing zeros; weights shown to 0.1 or 0.25, configurable increments).
- Changing units in settings changes display only; stored values never change.

### 4.3 Schema (example)

```json
{
  "schemaVersion": 1,
  "profile": {
    "name": "Aman",
    "gender": "male",
    "dob": "1998-04-12",
    "age": null,
    "ageSetOn": null,
    "weightKg": 74.5,
    "heightCm": 178,
    "photoFile": "profile_photo.jpg",
    "createdAt": "2026-10-13T18:30:00Z",
    "updatedAt": "2026-10-13T18:30:00Z"
  },
  "settings": {
    "weightUnit": "kg",
    "heightUnit": "cm",
    "weightIncrement": 2.5,
    "theme": "system",
    "quoteMode": "both",
    "backupReminder": true,
    "lastBackupAt": null,
    "activeSplitId": "split_ppl",
    "yearDots": {
      "layout": "continuous",
      "colorPreset": "light",
      "textLine": "left_and_percent",
      "topMarginPercent": 22,
      "padding": 24
    }
  },
  "splits": [
    {
      "id": "split_ppl", "name": "PPL", "isPreset": true,
      "days": [
        {"id": "day_push", "name": "Push", "order": 0, "exerciseIds": ["ex_bench", "ex_ohp"]},
        {"id": "day_pull", "name": "Pull", "order": 1, "exerciseIds": ["ex_row"]},
        {"id": "day_legs", "name": "Legs", "order": 2, "exerciseIds": ["ex_squat"]}
      ]
    }
  ],
  "exercises": [
    {
      "id": "ex_bench", "name": "Bench Press", "muscleGroup": "chest", "equipment": "barbell",
      "isCustom": false, "archived": false,
      "baselineMaxKg": 90,
      "maxWeightKg": 100, "maxWeightDate": "2026-10-10",
      "lastWeightKg": 95, "lastWeightDate": "2026-10-12",
      "notes": ""
    }
  ],
  "sessions": [
    {
      "id": "ses_001", "startedAt": "2026-10-12T17:00:00+05:30", "endedAt": "2026-10-12T18:05:00+05:30",
      "splitId": "split_ppl", "dayId": "day_push", "dayNameSnapshot": "Push",
      "entries": [
        {"exerciseId": "ex_bench", "exerciseNameSnapshot": "Bench Press",
         "sets": [{"weightKg": 95, "reps": 5, "isWarmup": false, "done": true}], "note": ""}
      ],
      "note": ""
    }
  ],
  "activeSession": null
}
```

### 4.4 Profile field rules

| Field | Required? | Rules |
|-------|-----------|-------|
| Name | **Mandatory** | 1–40 characters after trimming |
| Gender | **Mandatory** | `male`, `female`, `other`, `prefer_not_to_say` ("prefer not to say" is a valid answer) |
| Weight | **Mandatory** | 20–400 kg (equivalent in lb), decimals allowed |
| Height | **Mandatory** | 90–250 cm (or ft + in) |
| Date of birth **or** age | **Mandatory (one of the two)** | DOB must not be in the future; resulting age 13–100. If only age is entered, store `age` + `ageSetOn` so the displayed age keeps increasing over the years |
| Profile picture | Optional | Camera or gallery, cropped square. Placeholder avatar with initials when absent |

Age is **derived** from DOB whenever DOB exists. Never store a separately editable age next to a DOB.

### 4.5 Exercise rules
- **Max weight** = the highest weight across all completed, non-warm-up sets of that exercise, or `baselineMaxKg` if higher. `baselineMaxKg` lets the user enter a starting max from before they installed the app.
- **Last weight** = the heaviest completed, non-warm-up set of the **most recent session** that contained the exercise.
- Both are **recomputed from history** whenever a session is edited or deleted, so they can never drift. The stored `maxWeightKg` / `lastWeightKg` fields are a cache.
- Bodyweight exercises: weight `0` is allowed and displayed as "BW" (added weight is a normal weight).
- An exercise with history cannot be hard-deleted; it is **archived** (hidden from pickers, kept in history).
- Exercise names are unique (case-insensitive) among non-archived exercises.

---

## 5. Features

### 5.1 First-launch details gate (replaces sign-up/login)

**When it appears:** on first launch, and again any time no valid profile exists (fresh install, data reset, unrecoverable corruption). Once a valid profile exists, the app opens straight to Home. The back gesture cannot dismiss the gate.

**Layout, top to bottom:**
1. **"Restore from backup" button at the very top** of the screen (see 5.9 for the flow). If a restore succeeds and contains a valid profile, the gate is skipped.
2. Short friendly heading and one line explaining that data stays on this device.
3. **Unit choice first** (kg/cm or lb/ft-in) so the weight and height fields use the right units.
4. Form: profile picture (optional), name, gender (segmented chips), weight, height, date of birth (date picker, with an "I'd rather enter my age" toggle that swaps in an age field; the computed age is shown beneath the DOB).
5. Mandatory fields are marked clearly; optional ones say "Optional".
6. Primary button **Continue**. It stays enabled; on tap it validates, shows inline messages, and scrolls to the first error. (A silently disabled button is bad for usability and accessibility.)
7. **Draft persistence:** partially filled values are kept locally so killing the app mid-form loses nothing.

**Optional setup steps after Continue (both skippable with "Set up later"):**
- **Step 2: Pick a split.** Presets: PPL, Upper/Lower, Full Body, Bro Split, or "I'll create my own". Selecting a preset creates the split with default exercises from the seed library.
- **Step 3: Starting weights.** For the exercises in the chosen split, optionally enter a starting "max" and "last" weight so history isn't empty on day one. These become `baselineMaxKg` and an initial last-weight entry.

Then Home.

### 5.2 Profile
- Avatar in the Home header opens Profile. View and edit all fields above, with the same validation as the gate.
- Changing the photo replaces `profile_photo.jpg`.
- Show derived values: age, and optionally BMI (computed, display-only, with a neutral non-judgmental label).
- Editing weight just updates the current weight (a body-weight history is out of scope for v1; see Section 12).

### 5.3 Splits
- A **split** has a name and ordered **days** (e.g. Push, Pull, Legs, plus optional Rest days). Each day has an ordered list of exercises.
- Presets (editable copies) and fully custom splits. Multiple splits can exist; exactly one is **active**.
- Create/edit with drag-to-reorder for days and exercises; add exercises from the library with search and muscle-group filter; add custom exercises inline.
- **"Up next" logic:** the next day is the one after the most recently completed day of the active split, wrapping around (the way lifters actually rotate, not tied to calendar weekdays). The user can override and pick any day, or start a freestyle workout.
- Deleting a split never deletes past sessions (they keep a name snapshot).

### 5.4 Exercise library
- Bundled seed list of ~80 common exercises with muscle group and equipment (editable asset `assets/seed/exercises.json`).
- Add custom exercises (name, muscle group, equipment, optional starting max).
- List view with search and filters; each tile shows **Last** and **Max** as two soft "stat pills".
- **Exercise detail:** Max and Last (with dates), a progress chart over time (best weight per session), full log history, notes, edit baseline max, archive.

### 5.5 Workout logging
1. **Start:** from Home ("Up next: Pull") or Train tab (pick a day, or freestyle).
2. **Session screen:** the day's exercises in order. Each exercise card shows `Last 80 kg · Max 100 kg`, and a list of set rows.
3. **Set row:** weight and reps (reps optional), warm-up toggle, "done" check. New sets are **prefilled from the last session** (same weight, same reps). Weight has +/- steppers using the user's increment (default 2.5 kg / 5 lb) and can also be typed.
4. Add or remove sets; add an exercise ad hoc; reorder; per-exercise note.
5. **PR moment:** when a completed set exceeds the current max, show a quiet, tasteful acknowledgement (soft highlight plus a light haptic, no confetti storms) and label it "New max".
6. **Finish:** saves the session, recomputes last/max for touched exercises, shows a brief summary (duration, exercises, new maxes).
7. **Draft safety:** the in-progress session is saved to `activeSession` continuously, so killing the app never loses it. On next launch offer "Resume workout" or "Discard".
8. Sessions can be edited later (weights, reps, date) and deleted (with confirmation). Backdating a session is allowed.

### 5.6 Home
- Greeting with name and avatar.
- **Quote card** (see 5.7).
- **Up next** card (split day, exercise count) with a primary **Start workout** button; resume card if a draft session exists.
- Last session summary and simple week view (days trained this week). No streak-shaming; if streaks are shown they are optional and gentle.
- Backup reminder banner when appropriate (5.9).

### 5.7 Quotes
- Home shows one quote card with attribution (`Author` or `Character, Anime Title`; bundled quotes have none).
- **Quote mode setting:** Gym (bundled only), Anime (online anime, falls back to bundled), **Mix (default)**, Off.
- **Always available:** 24 curated gym quotes are bundled in the app (Appendix A). The card shows one instantly on launch, with no waiting and no empty state.
- **Online (when connected):** the app fetches more quotes directly from key-less public quote APIs (Section 6), validates them, and caches them. At most one background refresh per day, plus manual refresh within a local request budget.
- **Selection:** a shuffled queue from the available pool (bundled plus cached online, filtered by mode), never repeating the last 5.
- **Loader and transition states:**
  1. **Launch:** a bundled quote is shown immediately.
  2. **Refresh tap, next quote already cached:** instant swap with a crossfade (about 250 ms, light fade plus a small upward slide).
  3. **Refresh tap, live fetch needed:** the card shows a **skeleton shimmer in the shape of the quote** (two or three text lines and an attribution line) and the refresh icon becomes a small soft progress ring. Wait at most 5 s, then silently fall back to a cached or bundled quote.
  4. **Offline, rate-limited, or any failure:** no error message and no banner. The refresh button keeps cycling through cached and bundled quotes.
  5. **Reduce motion:** no shimmer or slide; use a static muted placeholder and a plain swap.
- Loaders are the shared `AppSkeleton` and `AppProgressRing` widgets (Section 7.2).

### 5.8 History & progress
- History list grouped by month; calendar dot view of trained days; tap a session for details.
- Per-exercise progress chart (on the exercise detail screen).
- Simple stats: sessions this month, total volume (optional), most improved exercise (optional). Keep it light.

### 5.9 Settings, Backup & Restore

**Settings sections:** Profile shortcut · Units (weight, height, weight increment) · Appearance (system/light/dark) · Quotes (mode) · **Backup & Restore** · About / Privacy / Licenses · **Reset all data** (danger zone).

**Backup file**
- Name: `gymtracker-backup-YYYY-MM-DD-HHmm.json`.
- Envelope:
```json
{
  "app": "gymtracker",
  "formatVersion": 1,
  "schemaVersion": 1,
  "appVersion": "1.0.0",
  "createdAt": "2026-10-13T18:30:00Z",
  "checksum": "<sha256 of the canonical JSON of payload>",
  "payload": {
    "profile": {}, "settings": {}, "splits": [], "exercises": [], "sessions": [],
    "photoBase64": "<profile photo, max 256px JPEG, optional>"
  }
}
```
- Includes **everything** the user entered: profile, photo, settings, splits, exercises (with maxes and baselines), all sessions. Excludes the quote cache and any in-progress draft (optional include).
- The checksum detects accidental corruption (it is not a security feature).

**Settings → Backup & Restore buttons**
1. **Save backup to device:** writes the file where the user can find it (Android: system "Create document" picker / Downloads; iOS: Files app via save sheet). Updates `lastBackupAt`.
2. **Share backup / Send on WhatsApp:** creates the file and opens the **system share sheet** with the file attached, where the user picks WhatsApp (or Drive, Files, email). On Android, add a direct "WhatsApp" button that targets the WhatsApp package intent (including WhatsApp Business) and falls back to the share sheet. On iOS, use the share sheet (WhatsApp appears there; apps cannot pre-target it with an attachment). Helper text: *"Tip: send it to yourself in WhatsApp to keep a copy."*
3. **Restore from backup:** file picker for the backup file (see below).
4. Show **"Last backup: 3 days ago"** (or "Never") with a gentle warning style if never or very old.

**Restore flow (same flow from the first-launch gate button and from Settings)**
1. User picks a file.
2. Validate: parseable JSON, `app == "gymtracker"`, checksum matches, structure valid. If `schemaVersion` is **newer** than the app supports, refuse with "Please update the app". If **older**, migrate.
3. Show a **preview**: name, number of exercises, number of sessions, backup date, whether a photo is included.
4. Confirm. Restore **replaces all current data** (no merge in v1). Before replacing, auto-save the current data as `pre_restore.json` in app storage so a mistaken restore can be undone once.
5. On success, reload app state; if a valid profile exists, go to Home.
6. Helper text on the restore screen explains how to restore from WhatsApp: *download the file in WhatsApp, then pick it here (iOS: tap "Save to Files" first).*
7. Errors are specific and kind ("This file isn't a Gym Tracker backup", "This backup looks damaged").

**Backup reminders**
- In-app banner when the last backup is older than 14 days **and** at least 5 sessions were logged since, or when there has never been a backup after 3 sessions. Dismissible. An optional local notification (weekly) can be toggled in settings.
- **Be honest in the UI:** a short info sheet explains that if the app is uninstalled or the phone is lost, data is gone unless a backup file was saved or shared.

**Reset all data:** requires typing a confirmation word, first offers to back up, then wipes data and returns to the first-launch gate.

### 5.10 Year Dots tab and wallpaper

A single calm screen that shows the whole year as small rectangular dots, one per day, so the user sees at a glance how much of the year is done and how much is left. **Nothing is entered or stored for this tab.** It is derived entirely from today's date, so it needs no data, no backup entry, and no network.

#### A. The Year tab
1. **New bottom-nav tab: "Year"** (dot-grid icon). Tabs become Home, Train, Exercises, Year, Settings.
2. **One screen, no scrolling.** The whole year fits in the visible area on phones and tablets, in portrait and landscape.
3. **Three states per dot:**
   | State | Look |
   |-------|------|
   | Done (every day before today) | Dark / filled (textPrimary-toned) |
   | Today | A distinct accent colour (accent sage or blush highlight), **plus a different shape cue** (slightly larger or outlined) so it is distinguishable without relying on colour |
   | Left (every day after today) | Very light, low-contrast (surfaceMuted) |
4. **Dots are small rounded rectangles** (width:height about 4:5, corner radius about 25% of width), with consistent gaps. Not circles.
5. **Layout: Continuous grid (default).** Jan 1 first, row-major left to right, top to bottom. The column count is chosen automatically to make the dots as large as possible while fitting the available area (algorithm below). A leap year shows 366 dots.
6. **Layout option: Months.** Twelve small month blocks in a 3-column × 4-row arrangement (or 4 × 3 in landscape/tablet). Each block is a weekday-aligned 7-column mini calendar with a tiny month initial above it. This reads better than one long grid and shows the shape of the year, but it is optional because the continuous grid is the simplest and matches the original idea. A toggle at the top of the screen switches between them (remembered in settings).
7. **A single quiet text line** under the grid: `Day 287 of 365 · 78 left · 79%`. No other content on the screen. (Day count includes today; "left" counts only days after today.)
8. **Tap or long-press a dot** to show a small tooltip such as "14 Mar · Day 73". This is also the accessibility path (see 8.2).
9. **Live updates:** the screen recomputes when the app resumes and at local midnight (timer to next local midnight). Use the **local calendar date** (year/month/day), never "24-hour" arithmetic, so DST and timezone changes can't produce an off-by-one. On Jan 1 the grid resets automatically.
10. Optional (off by default, **not in v1 unless the client asks**): highlight days the user trained. The user asked for nothing on top of the dots, so v1 stays pure.

#### B. Layout algorithm (must be identical in Dart, Kotlin and Swift)
Inputs: `N` (365 or 366), available `W × H` in px, gap ratio `g = 0.3`, aspect `a = 0.8` (width/height).
1. For each candidate column count `c` from 10 to 31: `rows = ceil(N / c)`.
2. Cell width `w = min( W / (c + (c-1)·g), (H / (rows + (rows-1)·g)) · a )`, cell height `h = w / a`, gap `= g · w`.
3. Choose the `c` that maximises `w` (ties: the smaller `c`). Centre the grid in `W × H`.
4. Months layout uses the same rule per block with 7 columns and up to 6 rows, then packs blocks in the 3×4 or 4×3 arrangement choosing whichever gives the larger dots.
5. **Parity tests:** keep a shared `layout_test_vectors.json` (sizes → expected cell rects for a few dates and years). Dart, Kotlin and Swift renderers must all pass the same vectors. This matters because the renderer exists in several languages.

#### C. Wallpaper feature (Settings → Year Dots wallpaper, and a button on the Year tab)
Goal: the user sees the year progress every time they look at their phone, updating daily.

**The honest platform picture:**
- **Android supports true live wallpapers.** The app can offer one.
- **iOS does not allow third-party live wallpapers.** No app can do this. The best available options are exporting a wallpaper image and, optionally, a Shortcuts automation that regenerates it daily.

**Wallpaper settings (kept small on purpose):** layout (Continuous / Months), colour preset (Light, Dark, Black/AMOLED, Sage), text line (days left + percent / days left only / none), top safe margin (default about 22% of height so the lock-screen clock and notifications don't cover the dots), padding. These settings live in the app's `settings.yearDots` and are included in backups.

**Android (v1): native live wallpaper**
1. Implement a Kotlin `WallpaperService` named "Year Dots". The wallpaper draws with Android `Canvas` using the native port of the layout algorithm. **Do not embed a Flutter engine in the wallpaper process** (memory and battery cost).
2. Configuration is passed from Flutter via a MethodChannel and stored in `SharedPreferences`, which the wallpaper reads.
3. **Redraw only when needed:** on `onVisibilityChanged(true)`, on surface size change, when the config changes, and at local midnight (a `Handler` scheduled to the next midnight, plus receivers for `ACTION_DATE_CHANGED`, `ACTION_TIME_CHANGED` and `ACTION_TIMEZONE_CHANGED` registered while the engine exists). No animation and no polling loop.
4. **Setting it:** a button "Set as wallpaper" opens the system live-wallpaper preview via `WallpaperManager.ACTION_CHANGE_LIVE_WALLPAPER` with this service as the component (fallback to the system live-wallpaper chooser). The user must confirm in the system dialog; an app cannot set it silently, and the user chooses home, lock, or both there.
5. The manifest declares the live-wallpaper feature as **not required** (`android:required="false"`), so the app still installs on devices without it. Hide the button when unsupported.
6. **Caveat to document and test:** some manufacturers (notably Samsung and a few others) restrict live wallpapers on the lock screen or apply their own handling. Provide the **static export** (below) on Android too as a fallback.
7. In-app **preview** at the top of the settings screen renders with the Flutter renderer and should look identical to the native one (parity tests, Section 11).

**iOS (v1): exported image**
1. **"Save wallpaper image"** renders a PNG at the device's exact pixel size (with the safe top margin for the lock-screen clock) and saves it to Photos (`NSPhotoLibraryAddUsageDescription`) or opens the share sheet. The user sets it as wallpaper from Photos.
2. Helper text explains that iOS doesn't allow live wallpapers, and that the image shows the date it was made.
3. **Stretch goal (build after everything else works):** a Swift App Intent / Shortcuts action "Year Dots Wallpaper" that returns today's image, so the user can create a daily Shortcuts automation (time of day) that sets it as wallpaper. It needs a small Swift renderer (a third implementation sharing the layout test vectors). Verify the current Shortcuts "Set Wallpaper" behaviour on the target iOS versions before promising a fully silent daily change; it may show prompts.

**Battery and performance:** the wallpaper must draw static content only, with CPU use near zero between redraws. Target one draw per visibility change or day change.

#### D. Data and backup impact
- No year data is stored; the tab always derives from the current date.
- Wallpaper preferences (`settings.yearDots`) are part of settings and therefore part of backups and restores. A restored backup must also re-push the config to the native wallpaper side.

---

## 6. Quote Sources (no backend in v1)

**Decision:** there is no server. The app ships with a small bundled set and fetches more directly from public APIs when online. Every source sits behind a `QuoteSource` interface, so a backend can be added later without touching the rest of the app.

### 6.1 Sources
| Source | Role | Notes |
|--------|------|-------|
| Bundled set | Always available | 24 curated original gym quotes (Appendix A), no attribution needed |
| AnimeChan | Online anime quotes | Key-less. Free anonymous tier is only **5 requests/hour** per client (1-hour block if exceeded). Community-contributed data: credit the anime and character |
| One key-less motivation/fitness API | Online variety | **Choose and verify at build time** (terms, limits, uptime, attribution). Record the choice in `docs/quote-providers.md` |

### 6.2 Rules
1. **Key-less APIs only.** Never use an API that needs a secret key: the key would ship inside the app and its quota would be shared by every user.
2. **Check terms first:** confirm each provider allows storing quotes on the device and showing them in a commercial app, and note the required attribution. If caching is not allowed, keep quotes in memory for the session only.
3. **Rate-limit budget tracked locally:** stay under each provider's limit (for AnimeChan, at most 3 requests per hour from the app). On a 429 or repeated errors, back off for an hour.
4. **Validate every quote in the app:** trim, strip HTML, reject empty or very long text (over 200 characters), apply a small profanity blocklist, dedupe by normalised text hash.
5. **Network hygiene:** HTTPS only, 5 s timeouts, no cookies, no user data or identifiers in requests. Providers will see the device's IP address; say so in the privacy policy.
6. **Failure is silent.** The bundled set guarantees the card is never empty.
7. **Attribution:** show author and source on the card, and list each provider's credit in About.
8. **Extensibility:** adding a source means one adapter file and one registration. If a provider changes or disappears, fixing it requires an app update, which is acceptable because the bundled set keeps the app working in the meantime.

### 6.3 Cache
`quotes_cache.json` (not part of backups): each entry holds `id` (text hash), `text`, `author`, `sourceTitle`, `category`, `provider`, `fetchedAt`. Keep the newest 100 entries and drop entries older than 30 days.

### 6.4 Adding a backend later (not in v1)
A DRF service would implement `QuoteSource`, which lets you hide API keys, curate and moderate quotes, and swap providers without an app release. Like everything here, it would store no user data.

---

## 7. Visual Design: Soft Minimalism

**Feel:** quiet, airy, warm, rounded, unhurried. Lots of whitespace, one accent colour, soft surfaces instead of hard borders. Calm rather than aggressive "gym bro" energy.

### 7.1 Starting tokens (refine, but keep the character)
Define in `design-tokens/tokens.json` and generate the Dart theme.

| Token | Light | Dark |
|-------|-------|------|
| background | `#F6F3EE` warm off-white | `#1E1D1B` soft charcoal (never pure black) |
| surface | `#FBF9F6` | `#272624` |
| surfaceMuted | `#EFEAE3` | `#302F2C` |
| textPrimary | `#2B2A28` | `#EFEBE5` |
| textSecondary | `#6B665F` | `#B4AEA5` |
| accent (sage) | `#5E8272` | `#9DB8A9` |
| accentSoft | `#DCE7E0` | `#34423B` |
| highlight (blush, for PRs) | `#E8C9BE` | `#5A4640` |
| danger (muted terracotta) | `#B85C4C` | `#D98A7C` |
| hairline | `#E7E1D8` | `#3A3834` |

- **Contrast:** soft palettes often fail accessibility. All body text and interactive text must meet **WCAG AA (4.5:1)**; verify with a contrast checker and adjust the tokens, don't just trust the table above.
- **Shape:** corner radius 16 (inputs), 24 (cards), pill (chips/stat pills). Spacing on a 4-pt scale, generous padding (16–24).
- **Depth:** no hard borders or heavy shadows; use very soft, large-blur, low-opacity shadows or tonal surfaces.
- **Typography:** a rounded humanist sans (e.g. DM Sans or Plus Jakarta Sans), **bundled as app assets** (the app is offline-first, so never fetch fonts at runtime). Large, tabular numerals for weights. Scale: display 32, title 20, body 16, caption 13 (nothing below 12).
- **Icons:** rounded outline set, consistent stroke.
- **Motion:** 200–300 ms ease-out fades/slides; respect the OS "reduce motion" setting; light haptics on set completion and new max.
- **Imagery:** minimal line illustrations for empty states; no stock gym photography.
- **One primary action per screen**, clearly the most prominent element.
- Light, dark, and system themes from day one.

### 7.2 Loading, transitions & feedback

All loaders and feedback are shared design-system widgets (`AppSkeleton`, `AppProgressRing`, `AppProgressSheet`, `AppToast`) with golden tests. Nothing is built per screen.

1. **No blank screens and no full-screen spinners.** Native splash, then the app shell, then **skeleton placeholders shaped like the real content** (exercise tiles, session cards, stat pills, the quote card).
2. **Anti-flicker rule:** show a skeleton only if loading takes longer than about 150 ms, and once shown keep it for at least about 300 ms.
3. **Shimmer:** soft, low-contrast (muted surface tokens), about 1.4 s loop. With reduce-motion on, use a static muted placeholder.
4. **Buttons:** while an action runs, the label is replaced by a small progress ring, the button keeps its width, and it ignores further taps.
5. **Long operations** (backup export, restore, wallpaper export): a progress sheet with an indeterminate bar and plain text, then a quiet success state (check mark) or a failure state with Retry.
6. **Transitions:** fade-through or shared-axis, 250-300 ms ease-out; animated insert/remove in lists; a light haptic when a set is completed. Everything respects reduce-motion.
7. **Optimistic updates:** logging a set updates the UI immediately and saves in the background; a save failure shows a toast with Retry.
8. **Empty states:** a minimal line illustration, one line of text, one action.
9. **Toasts:** soft pill at the bottom, about 3 s, with Undo where it makes sense (deleting a set or session).

---

## 8. Modular UI & Responsiveness (applies to every screen)

### 8.1 Modular structure
Same modular pattern as the Gym SaaS app: **small reusable widgets composed into feature modules, composed into thin screens.** Feature modules: onboarding, home, train (splits + session), exercises, history, year_dots, profile, settings, backup, quotes.

**Layers (each depends only on layers below):**
1. **Design tokens** (generated theme)
2. **Primitives (`design_system/`)**: AppButton, AppIconButton, AppTextField, AppChip, AppCard, AppSheet, AppToast, AppAvatar, AppSkeleton
3. **Composite widgets (`shared/`)**: StatPill (Last/Max), SetRow, QuoteCard, ExerciseTile, SplitDayChip, SearchField, FilterSheet, ConfirmDialog, EmptyState, ErrorState, UnitField (kg/lb, cm/ft-in), DatePickerField, PhotoPicker
4. **Feature widgets** inside each feature
5. **Screens**: only compose widgets and wire navigation

**Feature-first folders**, each with `data/`, `domain/`, `presentation/`. Rules:
- Features don't import each other's internals; share through `shared/` or a feature's public API file.
- Widgets are small, `const` where possible, take data via parameters. Logic lives in Riverpod providers/notifiers, never in widgets.
- No hard-coded colours, sizes, or text styles; tokens/theme only.
- Every data-driven widget handles loading, empty, and error states.
- Widgetbook (or similar) catalogue for the design system and shared widgets, viewable at phone and tablet sizes.

### 8.2 Responsive requirements
1. **Window size classes:** compact (< 600dp phones), medium (600–840dp), expanded (> 840dp tablets). One shared helper, no scattered `MediaQuery` checks.
2. **Navigation:** bottom navigation bar on compact; navigation rail on medium/expanded. Tabs: Home, Train, Exercises, Year, Settings (Profile via the Home avatar).
2a. **Year Dots screen:** the grid is computed from the available size (Section 5.10 algorithm), so it fits one screen with no scrolling on every size class and in both orientations. Each dot has a semantic label ("14 March, day 73, done / today / upcoming") and the tab is usable by screen reader through a summary label plus tap-to-inspect; today is distinguished by shape as well as colour.
3. **Content width:** cap readable content (~600dp) and centre it on large screens; use two-pane layouts on expanded (e.g. exercise list + detail, session list + detail).
4. **Session screen on tablets:** exercise list and the active exercise's sets side by side.
5. Works in **portrait and landscape**, with **system text scaling up to 200%**, no overflow or clipped content, keyboard-aware forms (no field hidden behind the keyboard).
6. Touch targets ≥ 48dp; respect safe areas, notches, and gesture bars.
7. Set logging must be comfortable **one-handed on a phone** (key actions in the lower half of the screen).
8. **Tests:** golden tests at phone and tablet sizes, light and dark, normal and large text scale, for every main screen.

---

## 9. Platform Specifics

### Android
- minSdk 23+, latest stable targetSdk.
- Use the system photo picker / camera intent so no broad storage permissions are needed. Camera permission only if capturing directly.
- Backup saving and restoring via the Storage Access Framework (create/open document); no legacy external-storage permissions.
- WhatsApp direct button via explicit package intent (`com.whatsapp`, `com.whatsapp.w4b`), with a share-sheet fallback.
- **Decision to confirm:** keep `android:allowBackup` at its default (enabled) so Android's own device backup can restore app data on reinstall or a new phone. This is the OS's backup, not ours, and sends nothing to our servers. Recommended: leave it on, and say so in the privacy text. Set `fullBackupContent`/data-extraction rules to exclude `quotes_cache.json`.
- Adaptive launcher icon, splash screen, edge-to-edge.
- Declare the `INTERNET` permission (quote fetching only); cleartext traffic disabled.
- **Live wallpaper service** for Year Dots (Section 5.10): manifest service with the `android.service.wallpaper.WallpaperService` intent filter, wallpaper meta-data XML, `uses-feature android.software.live_wallpaper` with `required="false"`. Test on at least one Samsung device because lock-screen handling of live wallpapers varies by manufacturer.

### iOS
- iOS 14+.
- `Info.plist`: `NSCameraUsageDescription`, `NSPhotoLibraryUsageDescription` with friendly purpose strings; `LSApplicationQueriesSchemes` including `whatsapp` only if checking for installation.
- Backups saved through the share sheet "Save to Files". The app's documents are included in standard iCloud device backups by default; mirror the Android decision above in the privacy text.
- Year Dots on iOS = exported wallpaper image (add `NSPhotoLibraryAddUsageDescription`); iOS has no third-party live wallpapers. The Shortcuts App Intent is a stretch goal (Section 5.10).
- Include the required **privacy manifest** (`PrivacyInfo.xcprivacy`) and verify that plugins' manifests are present.
- App Store privacy answers: no accounts and no user data collected. The only network traffic is quote fetching from public APIs, which see the device's IP address. Keep App Transport Security at its HTTPS-only default and describe this honestly in the privacy policy.

### Both stores
- A **privacy policy** page (hosted URL plus in-app screen) stating: no accounts, data stays on device, what quote providers can see (the IP address), how backups work.
- Not a medical app: include a short "not medical advice" line in About.

---

## 10. Non-Functional Requirements

- **Performance:** cold start to interactive < 2 s on a mid-range phone with ~2 years of logs; 60 fps scrolling; parse data in an isolate; lazy-load history.
- **Reliability:** atomic writes, `.bak` fallback, and crash-safe draft sessions are release blockers.
- **Accessibility:** semantics labels, dynamic type to 200%, AA contrast, no information conveyed by colour alone, reduce-motion support.
- **Localization-ready:** strings externalised (`intl`/ARB) so Hindi can be added later; English only in v1. Numbers and dates use the device locale.
- **Security:** no secrets in the app; HTTPS only; backup files are plain JSON (document this honestly, and offer optional password-protected backups as a later enhancement).
- **Observability:** none that uploads user data. Local debug logs only, off in release.

---

## 10A. Engineering Standards & Scalability (Flutter app)

**Goal:** a codebase where new features, new data types, new quote providers and new screens can be added without touching or breaking existing code. "Scalable" here means **easy to change and extend safely**. It does not mean distributed systems. Do not add microservices, event buses, plugin frameworks or generic abstractions without a present need. **Abstract only at real seams:** storage, network, clock, file system, platform channels (wallpaper, share), quote providers, and backup sections.

### 10A.1 Code style (both codebases)
1. **Comments are rare.** Names and structure carry the meaning. A comment is allowed only to explain a non-obvious *why* (a platform quirk, a workaround, a business rule), in **one or two lines**. Not allowed: comments that restate the code, section-banner comments, narration ("// now we save the user"), commented-out code, and TODOs without a ticket reference.
2. **Doc comments** only on the public API of shared packages/modules, in one line where possible.
3. Small units: one public class per file, functions that do one thing, files rarely above ~300 lines, widgets/methods rarely above ~60 lines. Split by responsibility, not by line count alone.
4. Clear, consistent naming: nouns for classes, verbs for functions, no abbreviations, booleans read as questions (`isDone`, `hasPhoto`).
5. No magic numbers or strings: constants live in tokens, config, or named constants.
6. No dead code, no unused dependencies, no copy-pasted blocks (extract on the second duplicate with real shared meaning).
7. Formatting and linting are automated and enforced, never debated in review (see 10A.5).

### 10A.2 Flutter architecture
1. **Feature-first clean architecture.** Each feature has `presentation/` (screens, widgets, state notifiers), `domain/` (entities, repository interfaces, use-cases), `data/` (DTOs, mappers, repository implementations, data sources). **Dependencies point inward:** presentation → domain ← data. `domain/` is **pure Dart** (no Flutter, no I/O imports), enforced by an import-lint rule in CI.
2. **Three model types, never mixed:** DTOs (JSON shape, data layer), domain entities (immutable, freezed), UI state. Mappers convert between them. A schema change touches DTOs and mappers, not the UI.
3. **Dependency injection through Riverpod providers.** Every external dependency sits behind an interface and is injectable and fakeable: `DataStore`, `FileGateway`, `ShareGateway`, `WallpaperGateway`, `QuoteApi`, `NotificationGateway`, and a **`Clock`** (all date logic, including Year Dots and "up next", uses the injected clock so it is testable and DST-safe).
4. **Typed error model.** A sealed `Failure` hierarchy (e.g. `StorageFailure`, `ValidationFailure`, `NetworkFailure`, `BackupFailure`). Data sources convert exceptions to failures at the boundary; the UI only handles typed failures and shows friendly messages. No raw exceptions reach widgets.
5. **Extension points (add a feature by adding a folder, not by editing the core):**
   - **Navigation registry:** tabs/routes are registered by each feature; adding a tab does not edit the shell's code.
   - **`BackupContributor` interface:** each feature that owns persisted data registers a contributor that exports, validates, restores and migrates its own section of the backup. The backup envelope is assembled from registered contributors, so a new data type is **included in backups automatically and cannot be forgotten**.
   - **Migration pipeline:** ordered, individually tested migrations per schema version for both the data file and backups.
   - **Feature flags:** local switches (e.g. online quotes on/off). Remote flags are out of scope without a backend.
6. **Storage swap-ability:** the domain depends on repository interfaces only; moving from the JSON file to SQLite later changes the data layer alone.
7. **Typed routing** with go_router, route definitions colocated with each feature.
8. **Environments:** flavors `dev`, `staging`, `prod` (separate app IDs, API base URLs through `--dart-define`/flavor config). No secrets in the app.
9. **Package structure:** start as folders with enforced import rules; extract `core`, `design_system` and `shared` into local packages (melos workspace) once stable, so boundaries are compiler-enforced.
10. **Logging:** a thin logger interface with levels, local only, no personal data, disabled or reduced in release.

### 10A.3 Quote sources and a future backend
Quote sources sit behind a `QuoteSource` interface with a registry. Fetch, validate, dedupe and cache are separate, individually testable steps. Adding a source is one adapter file plus one registration. If a backend is added later, it implements `QuoteSource` and the rest of the app does not change.

### 10A.4 Documentation and decisions
- Short `README` per app and per feature (what it owns, how to run its tests). No long prose.
- **Architecture Decision Records** in `docs/adr/` for significant choices (storage format, provider selection, backup format). One page each.
- An architecture overview diagram (layers, data flow, the backup contributor flow) in `docs/architecture.md`.
- `docs/adding-a-feature.md`: a checklist for the standard way to add a feature, tab, data section or quote provider.

### 10A.5 Quality gates and workflow
| Area | Standard |
|------|----------|
| Format + lint | `dart format`, strict analyzer rules (strict casts/inference/raw types, `very_good_analysis` or equivalent), import-lint for layer boundaries |
| Tests | Unit (domain ≥ 85% coverage), widget, golden, integration. Prefer hand-written fakes over heavy mocking. Quote sources tested with recorded fixtures, no live calls in CI |
| Security | dependency audit, secret scan |
| Hooks | pre-commit: format, analyze, affected tests |

- **Git workflow:** trunk-based with short-lived feature branches, small PRs, **Conventional Commits**, PR template with a checklist, `CODEOWNERS`, at least one review, CI required to pass before merge.
- **CI (on every PR):** format check, static analysis, full tests, coverage gate, debug build (Android + iOS).
- **CD:** tagged semantic versions, automated changelog, signed release builds (Android AAB, iOS archive) through a pipeline (e.g. Fastlane with GitHub Actions or Codemagic), staged rollouts.
- **Dependencies:** pinned versions, automated update PRs (Renovate/Dependabot), new dependencies require a one-line justification in the PR. Prefer fewer, well-maintained packages.
- **Performance budgets** enforced in CI where feasible: app size, cold start, jank on the main screens.

### 10A.6 Review checklist (every PR)
Layer boundaries respected · no logic in widgets/views · typed errors, no swallowed exceptions · new persisted data has a `BackupContributor` and a migration · date logic uses the injected clock · no hard-coded styles or strings · tests added or updated · no stray comments, dead code or TODOs · docs/ADR updated if a decision changed.

---

## 11. Testing

1. **Storage:** atomic write survives a simulated crash; corrupted primary falls back to `.bak`; both corrupted shows recovery screen; schema migration tests.
2. **Backup round-trip (critical):** populate data → export → wipe → restore → state is identical, including the photo and settings. Also: tampered checksum rejected, newer schema rejected, older schema migrated, wrong file type rejected, `pre_restore.json` created.
3. **Domain logic:** max/last recomputation after edit/delete, baseline handling, bodyweight exercises, "up next" rotation, unit conversions (kg↔lb round-trips don't visibly drift), age from DOB and age-only drift.
4. **Gate:** validation of every field, draft persistence, restore-from-top-button path, gate not shown again after completion, gate shown again after reset.
5. **Widget/golden tests** per Section 8.2; **integration test:** first launch → gate → pick split → log a workout (new max) → backup → reset → restore → data intact.
6. **Quotes and loaders:** source adapters tested with recorded fixtures (no live calls in CI); validation, dedupe, cache limits; rate-limit budget and backoff; timeout and silent fallback; widget and golden tests of skeleton, progress and crossfade states, including reduce-motion.
7. **Year Dots:** day-of-year and days-left maths for normal years, leap years, Jan 1 and Dec 31; local-date handling across DST changes and timezone changes (no off-by-one); midnight rollover while the app is open; **layout parity**: the Dart, Kotlin (and Swift, if built) renderers all pass the shared `layout_test_vectors.json`; golden tests of the Year tab at phone and tablet sizes in both layouts and all colour presets; wallpaper redraws on date change and visibility change without a polling loop.
8. Manual device checks on at least one real iPhone and one real Android phone (including a Samsung), plus one tablet each, before release.

---

## 12. Out of Scope for v1 (design so they can be added)

- Accounts, cloud sync, multi-device sync, social features
- Body-weight history and body measurements over time
- Rest timer, plate calculator, supersets, RPE, estimated 1RM
- HealthKit / Health Connect integration
- Password-protected or encrypted backups
- Merge-restore (v1 restore replaces everything)
- Push notifications (a simple optional local backup reminder is allowed)
- Languages other than English
- A backend, remote quote curation, remote config and forced updates (can be added later behind `QuoteSource`)
- Home-screen / lock-screen widgets (including a Year Dots widget, a good iOS alternative later), Apple Watch / Wear OS
- Marking workout days on the Year Dots grid, browsing past or future years, per-day notes

---

## 13. Decisions Already Made (do not re-ask)

| Topic | Decision |
|-------|----------|
| Accounts | None. First-launch details gate instead |
| "Every first open" | Gate shows whenever no valid profile exists (first install, reset, unrecoverable corruption), not on every launch |
| Mandatory fields | Name, gender, weight, height, and DOB-or-age |
| Optional fields | Profile picture. Split and starting weights are skippable setup steps |
| Gender options | male, female, other, prefer not to say |
| Min age | 13 |
| Storage | Single versioned JSON file + separate photo file, atomic writes with `.bak` |
| Canonical units | kg and cm in storage; display unit is a setting |
| Max / last weight | Derived from history (plus baseline max); stored values are a cache |
| Backup format | Single `.json` file with checksum; photo embedded as small base64 |
| Restore | Replace-all with preview, confirmation, and one-step undo snapshot |
| WhatsApp | Via system share sheet (plus Android direct-package button). No silent sending |
| Restore entry points | Button at the top of the first-launch gate, and in Settings |
| Backend | None in v1. A DRF backend can be added later behind `QuoteSource` |
| App → third-party APIs | Directly, key-less APIs only, no user data sent, never an API that needs a secret key |
| Bundled quotes | 24 curated original gym quotes (Appendix A); no copyrighted anime dialogue bundled |
| Quote loading | Never blocks the UI: bundled quote shown instantly, skeleton shimmer during a live fetch (5 s max), silent fallback |
| App updates | Store update prompts only (no forced-update mechanism in v1) |
| OS-level device backup | Left enabled (decision to confirm with the client) |
| Design | Soft minimalism, light/dark/system, bundled fonts |
| UI pattern | Modular UI, responsive everywhere (phone + tablet, portrait + landscape) |
| Year Dots tab | Fifth tab, one screen, small rounded-rectangle dots: done = dark, today = accent colour plus shape cue, left = light. Derived from the date, nothing stored |
| Year Dots layouts | Continuous grid (default) and Months (3×4 weekday-aligned blocks) |
| Year Dots day maths | Day count includes today; "left" counts only days after today; local calendar date, not 24-hour arithmetic |
| Android wallpaper | True native Kotlin live wallpaper, no Flutter engine inside, redraws only on visibility/midnight |
| iOS wallpaper | No live wallpaper possible. Exported image in v1; Shortcuts App Intent is a stretch goal |
| Wallpaper settings | Layout, colour preset, text line, top margin, padding. Included in backups |
| Architecture | Feature-first clean architecture, dependency injection, typed errors |
| Scalability meaning | Easy and safe to extend, not distributed infrastructure. Abstract only at real seams |
| Backup extensibility | Backup built from registered `BackupContributor`s so new data is never left out |
| Code comments | Minimal: one or two lines of "why" only. No narration, banners or commented-out code |

---

## 14. Roadmap

> Format: Month → numbered tasks. Each task has a clear "done" condition.

### Month 1: Foundation, Data & Core Workout Flow
1. Write `docs/plan.md`; scaffold repo and Flutter project (flavors dev/staging/prod); **engineering baseline per Section 10A**: strict lints and formatters, import-lint for layer boundaries, pre-commit hooks, CI quality gates, DI container, `Clock`, typed `Failure` model, logger, ADR and `adding-a-feature` docs
2. Design tokens (soft minimalism, light/dark), generated Dart theme, bundled fonts, design-system primitives, shared loaders (skeleton shimmer, progress ring, progress sheet), widget catalogue
3. Responsive shell: window size classes, bottom nav / rail, content-width wrapper, golden-test harness
4. Data layer: `DataRepository`, JSON file store with atomic writes, `.bak` recovery, isolate parsing, schema versioning + migration framework, unit conversion utilities (with tests)
5. First-launch gate: unit choice, profile form, validation, photo pick/crop/resize, draft persistence, optional split and starting-weights steps
6. Seed assets: ~80 exercises, preset splits; exercise library screens with search/filter and custom exercises
7. Splits: create/edit/reorder, active split, "up next" logic
8. Workout session: prefilled set rows, steppers, draft session persistence, finish flow, max/last recomputation, new-max moment

### Month 2: History, Backup, Quotes & Release
1. History list/calendar, session edit/delete, exercise detail with progress chart
2. Profile screen and Settings (units, theme, increments, reset all data)
3. Backup export (save to device), share sheet + Android WhatsApp direct button, `lastBackupAt`
4. Restore flow with validation, preview, `pre_restore.json`, and the **Restore button at the top of the gate**; round-trip tests
5. Backup reminders (banner + optional notification) and the "what happens if you uninstall" info sheet
6. Quotes: `QuoteSource` interface, bundled 24-quote set, cache, key-less online sources (AnimeChan plus one verified motivation API) with local rate-limit budget and validation, quote-mode setting; write `docs/quote-providers.md` after checking terms
7. Quote card loading states: skeleton shimmer, progress ring, crossfade, silent fallback, reduce-motion variants; startup skeleton for Home
8. Year Dots tab: layout algorithm + shared test vectors, Continuous and Months layouts, today/done/left styling, midnight refresh, tooltip and accessibility labels
9. Android live wallpaper: Kotlin `WallpaperService` renderer, config bridge, "Set as wallpaper" flow, redraw-on-date-change, parity tests, Samsung check; iOS exported wallpaper image; (stretch) iOS Shortcuts App Intent
10. Accessibility pass (large text, contrast, screen reader), performance pass, tablet layouts
11. Store prep: privacy policy, iOS privacy manifest and permission strings, Play Data Safety and App Store privacy answers, icons, splash, screenshots; real-device QA; release build

---

## 15. Definition of Done (per feature)

- [ ] Works fully offline (except fetching new quotes)
- [ ] Persists correctly through app kill and restart; data survives a simulated crash mid-save
- [ ] Included in backup and restored correctly (round-trip test updated)
- [ ] Unit conversions and validation verified
- [ ] Built from shared design-system/shared widgets, tokens only, no hard-coded styles
- [ ] Verified at phone and tablet sizes, portrait and landscape, light and dark, and at 200% text scale
- [ ] Loading, empty, and error states handled
- [ ] Unit/widget tests written and green; golden tests updated
- [ ] No user data sent anywhere
- [ ] Follows Section 10A: layer boundaries respected, interfaces injected, typed failures, strict lint/format clean, no stray comments or dead code
- [ ] Any new persisted data has a `BackupContributor` and a migration

---

## 16. First Prompt to Give Claude Code

> "Read `gym-tracker-app-requirements.md` fully. Then write `docs/plan.md` with the repo layout, the pinned package list with a one-line reason per package, and any ambiguities or risks you found. Do not write feature code yet. After I approve it, begin Month 1, Task 1 and proceed task by task, stopping after each task for review."

---

## Appendix A. Bundled Quotes (24)

Ship as `assets/quotes/bundled_quotes.json` with the shape `{"id": "q01", "text": "...", "author": null, "category": "gym"}`. These are original lines (no attribution, no licensing concerns). Keep them as written; the list can be edited later.

1. Show up. The rest follows.
2. Small weights, steady hands, big years.
3. Today's set is tomorrow's strength.
4. You don't need motivation. You need the next rep.
5. Progress is quiet until it isn't.
6. Lift today. Thank yourself tomorrow.
7. Strong is built on the boring days.
8. Add a little. Repeat often.
9. Consistency beats intensity.
10. Rest is part of the plan, not a break from it.
11. Your only race is with last month's you.
12. The bar doesn't care about your mood.
13. Warm up, then let it get heavy.
14. Slow reps still count.
15. Every rep is a vote for who you're becoming.
16. Start where you are. Use what you have.
17. Strength is patience with a barbell.
18. Missed a day? Be back tomorrow.
19. Heavy is relative. Keep moving up.
20. Breathe. Brace. Begin.
21. Form first. Weight follows.
22. Earn the rest day.
23. Build slowly. Build for years.
24. One good session is enough for today.
