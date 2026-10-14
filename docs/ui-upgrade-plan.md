# UI upgrade plan: warm, gamified, daily check-in

Status: **approved and built** (2026-10-14). Deviations are logged as D54–D57.
Brief: `docs/ui-upgrade-requirements.md`. Base spec: `docs/requirements.md` (architecture, data, backup, offline, testing and code rules all still apply).

Contents: 1. Summary · 2. Design tokens · 3. Navigation and screens · 4. Check-in and streak rules · 5. XP, levels and badges · 6. Schema change · 7. Architecture · 8. Build steps · 9. Risks and open questions · 10. Proposals (not built without approval)

---

## 1. Summary

- **New feature:** one check-in per day ("Did you work out today?"), with an optional note, time and duration. Today, past days and future days (plan only) are all editable.
- **Streak:** counted in workout days, held together by weekly goals (1–6 days a week, Sunday is a bonus rest day). Shown as one big number with a flame.
- **Rewards:** XP, levels, 13 badges and short celebrations. All are derived from your data, so they can't drift.
- **Look:** warm ember, gold and coral on cream (light) or warm brown-charcoal (dark). Bigger buttons, softer shadows, a bold display font for numbers and headings.
- **Navigation:** Home, Plan, Train, Stats, Me. Nothing is removed: Exercises moves into Train, Year Dots into Stats, Settings into Me (Section 3).
- **Data:** schema version 2 adds `checkIns` and `rewards` sections, with a tested migration. Both are covered by backup automatically.

---

## 2. Design tokens

All values go in `design-tokens/tokens.json`. The generator rebuilds the Dart theme and the Kotlin wallpaper palette. Nothing is hard-coded.

### 2.1 Colours (contrast ratios checked with the WCAG formula)

| Token | Light | Dark | Used for |
|-------|-------|------|----------|
| background | `#FFF7EE` cream | `#1F1612` warm brown-charcoal | Screens |
| surface | `#FFFCF8` | `#2A1F1A` | Cards, sheets |
| surfaceMuted | `#F7EADB` | `#3A2B24` | Tracks, empty days, inputs |
| textPrimary | `#2A1B14` (15.6:1 on bg) | `#FBEFE4` (15.7:1) | Body and headings |
| textSecondary | `#6B5446` (6.6:1 on bg, 6.0:1 on muted) | `#CDB8A8` (9.3:1) | Supporting text |
| accent | `#C2410C` deep ember (4.9:1 on bg) | `#FF8A4C` (7.6:1) | Primary buttons, links, focus |
| onAccent | `#FFFFFF` (5.2:1) | `#1F1612` (7.6:1) | Text on primary buttons |
| ember | `#F26B2D` | `#FF7A3D` | Brand graphics only: flame, rings, done days, gradients |
| onEmber | `#2A1B14` (5.5:1) | `#1F1612` (6.9:1) | Icons and text on ember |
| gold | `#F5A524` | `#FFC14D` | Streak, XP, badges (fills) |
| onGold | `#2A1B14` (8.1:1) | `#1F1612` (11.0:1) | Text on gold |
| goldText | `#8A5300` (6.0:1 on bg) | `#FFC14D` (11.0:1) | Gold-toned text (XP numbers) |
| highlight (coral) | `#F47C7C` | `#FF8F8F` | Celebrations, PRs |
| onHighlight | `#2A1B14` (6.3:1) | `#1F1612` (8.1:1) | Text on coral |
| highlightText | `#B0353F` (5.8:1 on bg) | `#FF9E9E` (9.0:1) | "New max" label |
| accentSoft | `#FFE9DC` | `#4A2A1C` | Selected chips, soft fills (textPrimary only on top) |
| danger | `#A8322A` (6.3:1; white on it 6.7:1) | `#FF9B8A` (8.7:1) | Destructive actions |
| hairline | `#F0E2D2` | `#3E2E26` | Dividers |
| shadow | `#5A2E12` at 8% | none (tonal surfaces instead) | Soft card shadows |
| heroGradient | surface → `#FFE9DC` | surface → `#3A2219` | Streak hero card, welcome hero |

Findings that change your suggested values:
- **White text on `#F26B2D` is only 3.0:1, which fails AA.** Primary buttons use the deeper ember `#C2410C` with white text (5.2:1). The bright `#F26B2D` stays the brand colour for the flame, rings and done-day fills, where it carries no text (or carries dark `onEmber` text at 5.5:1).
- **Ember on cream is 2.9:1, below the 3:1 rule for graphics.** Done days therefore always carry a check icon as well, and the ring always has a "3 of 4" text label, so nothing depends on colour alone.
- **Two pairs are banned** and listed as not allowed in `tokens.json`: accent on accentSoft (4.0:1) and accent on surfaceMuted (4.4:1). The existing contrast test runs every allowed pair in both modes.

**Year Dots wallpaper presets** become Light (cream), Dark (warm charcoal), Black (AMOLED, unchanged) and **Ember**, which replaces Sage. The migration maps a stored `sage` value to `ember`.

### 2.2 Type, shape, depth and motion

| Area | Change |
|------|--------|
| Fonts | **Display:** Bricolage Grotesque, bold and friendly but not childish (OFL), bundled at weights 700 and 800, for headings and big numbers. Before adopting it I'll check with fontTools that it has the glyphs and tabular figures; the fallback is Outfit. **Body:** Plus Jakarta Sans stays, and the weights in the logger stay in its tabular figures. |
| Type scale | Adds `hero 56` for the streak number. The rest stays: display 32, headline 24, title 20, body 16, label 14, caption 13. At 200% text the hero number caps at 1.5× (`MediaQuery.withClampedTextScaling`) and keeps a full semantic label. |
| Radius | input 18, card 24, hero 28, sheet 28, pill 999 |
| Buttons | Primary 56 dp tall, full width on phones, bold label. Secondary is a tonal fill. All tap targets are at least 48 dp. |
| Shadow | Warm brown shadow, blur 32, y 12, 8% opacity in light mode. Dark mode uses tonal surfaces plus a faint ember glow on the hero card. |
| Flame tiers | 0: outline flame in textSecondary ("Fresh start"). 1–6: small ember flame. 7–29: ember with a gold core. 30–99: larger, with a soft glow. 100+: gold glow ring. Sizes and glow radii are tokens. |
| Motion | fast 200, normal 250, slow 300 (unchanged). New: `pulseMs 600` for the flame pulse, `celebrationMs 1200` for the celebration overlay. Reduce-motion gives a static check and a fade. |

---

## 3. Navigation and screens

### 3.1 Tabs (recommendation)

**Home · Plan · Train · Stats · Me.** Five tabs, each with an icon and a label (bottom bar on phones, rail on tablets).

| Today | Where it goes | Taps from Home |
|-------|---------------|----------------|
| Exercises tab | Train gets a top segmented control: **Workouts \| Exercises** | 2 |
| Year tab | Stats has a "Your year" card that opens the full-screen Year Dots (the one-screen rule still holds) | 2 |
| Settings tab | **Me**: a profile card at the top, then the settings list (goal, reminder, units, look, quotes, Year Dots wallpaper, backup, about, reset) | 1 |
| History (from Home) | Train gets "Past workouts"; the Plan day sheet links "View workout" when a session exists | 2 |

Why: the check-in loop (Home, Plan, Stats) is now the daily path, so it earns tabs. Exercises and history are part of training. Year Dots is a "look at your year" view, which fits Stats.

### 3.2 Screens

| Screen | Change |
|--------|--------|
| App shell | New tab set. Rail labels are always visible. |
| **Home** (rebuilt) | 1. Greeting, avatar (opens Profile) and a compact quote card. 2. **Streak hero card**: flame, big number, weekly ring "3 of 4 days", status line, XP bar with level. 3. **Today card**: big "I worked out today" button; once done it shows a check, "Undo" and "Add note or time". If the active split has an up-next day, a secondary "Start workout" button. The resume-draft card replaces it while a draft exists. 4. **Week strip** Mon–Sun; tapping a day opens its day sheet. 5. **Next badge** teaser. 6. Two buttons: "Plan" and "Stats". The backup reminder banner stays. Tablet: two columns. |
| **Plan** (new) | A week strip on top (swipe or arrows to change week), a month grid below (arrows to change month) and a small legend. Tapping a day opens the **day sheet**. Empty state: "Plan your week: tap a day to add a note." |
| **Day sheet** (new) | Done toggle, note (up to 120 characters), time picker, duration chips (15/30/45/60/90 or custom). Future days: note and planned time only, with "You can tick this off on the day." If a session exists: "Workout logged at 6:30 PM" and "View workout". |
| **Stats** (new) | Current and best streak, weeks on track, total workouts, this week and this month, consistency %, a month heatmap, last 8 weeks (bar chart, done vs goal), time of day (morning/afternoon/evening/night bars, shown only if times exist), badges grid, and the "Your year" card. Each block has its own friendly empty state. |
| **Badges** (from Stats) | Grid of BadgeTiles. Earned tiles show the date; locked tiles show progress ("7 of 10 workouts"). |
| Train | Segmented Workouts \| Exercises, a "Last workout" card (moved from Home), and "Past workouts". Otherwise unchanged. |
| Session / Summary | Restyled. The quiet "New max" stays; the summary adds "+35 XP" and any badge earned. |
| Exercises, Exercise detail, History, Session detail/edit | Restyle only (tokens, components). Calendars switch to Monday-first. |
| **Onboarding** | Welcome hero (warm gradient, flame mark), the "data stays on this device" line, the restore button at the top, and a step indicator. Steps: 1 **Your details** (existing gate, restyled fields, gender chips, polished photo picker with initials) → 2 **Weekly goal** (new: big chips 1–6, default 4, "Sunday is your rest day") → 3 **Pick a split** (skippable) → 4 **Starting weights** (skippable) → **You're all set** (a short celebration, then Home). Validation, draft persistence and skip rules are unchanged. Skipping step 2 keeps the default goal of 4. |
| **Me** (was Settings) | Profile card at the top, plus new rows "Gym days per week" and "Daily reminder". The other rows stay as they are. |
| Year Dots, wallpaper settings, Backup, Recovery | Restyle only. Year Dots routes stay; only the tab entry moves. |

**Copy rules:** plain words, always positive. The UI never shows the word "missed": a past day without a workout reads "No workout", drawn as a neutral empty dot. The status lines are in 4.4.

---

## 4. Check-in and streak rules

### 4.1 Days

- Each local calendar date (`YYYY-MM-DD`) has at most one check-in. Dates are compared and stepped as calendar dates, never with 24-hour arithmetic, so DST changes and time-zone travel can't shift a day.
- **A day counts as a workout day** when you marked it Done. If you never touched it, it counts when a finished workout session started on that date. **Your explicit choice always wins:** unmarking a day that has a session makes it not count (the session stays in history).
- If you didn't set them, time and duration come from that day's session (the first start time, and the total length).
- **Future days:** note and planned time only; Done can't be set. Today and past days can be marked and unmarked freely.

### 4.2 Weeks and goal

- A week runs **Monday to Sunday**, identified by its Monday's date. Mon–Sat are regular days and **Sunday is the bonus day**.
- **Goal for a week** = the goal-history entry with the latest `effectiveFrom` that is on or before that week's Monday. Weeks before the first entry use the first entry. With no entries at all, the goal is 4.
- Changing the goal writes `{effectiveFrom: this Monday, days}`, replacing any entry already dated this Monday. Past weeks keep their old goal.
- **A week is met** when its workout days, Sunday included, reach the goal.

### 4.3 The streak, in plain words

1. The streak counts **workout days**. Every workout day adds 1, Sundays included.
2. Skipped days never matter on their own. What matters is whether each week can still reach its goal.
3. **A week is "lost" the moment its goal can no longer be reached**, even by training every remaining day including Sunday. Only then does the streak end. Before that, nothing breaks early.
4. When a week is lost, the streak resets to 0 ("Fresh start") and the **best streak** keeps the old number.
5. **The next workout starts a new streak at day 1, even later in that same week.** That week is not checked again, so the new streak gets a fair start. Its first full week then has to meet the goal as usual. This also means someone who installs on a Friday can begin a streak straight away.
6. **Weeks on track** counts the met weeks in the current streak. The current week counts as soon as it is met.
7. Everything is recomputed from stored days on every change. Backfilling a forgotten day can restore a streak, and unmarking a day can end one. It's your log, so it reflects your edits.

As a function: walk every day from the Monday of your first workout's week up to today. Add 1 on each workout day. After each finished day, if this week isn't already lost and `goal − done so far > days left in the week after this one`, end the streak and mark the week lost. Track the highest value as the best streak.

### 4.4 Status line (current week)

`needed = goal − workout days so far this week`. `open days` = remaining days this week, Sunday included, plus today if it isn't done yet.

| State | When | Line |
|-------|------|------|
| Met | needed ≤ 0 | "On track: this week's goal is done" |
| On track | needed < open days | "1 more to go this week" / "3 more to go this week" |
| Last chance | needed = open days | "Last chance today" (if needed is 1) / "Train today to stay on track" |
| Fresh start | no streak (0), or this week was already lost | "Fresh start today" / "New streak: day 2" |

### 4.5 Worked examples (October 2026: Mon 12 to Sun 18; earlier week Mon 5 to Sun 11)

**A. Skipped days don't break anything** (goal 4). Mon, Tue, Thu and Sat are trained; Wed and Fri are skipped.
- Wed morning: 2 done, 2 needed, 5 open days (Wed–Sun) → "2 more to go this week".
- End of Fri: 3 done, 1 needed, 2 days left (Sat, Sun) → still fine.
- Sat trained → met. The streak gains 4 days and weeks on track gains 1.

**B. Three leave days plus a Sunday bonus** (goal 4). Mon, Tue and Wed are trained; Thu, Fri and Sat are leave.
- End of Sat: 3 done, 1 needed, 1 day left (Sun) → not lost, because 1 is not more than 1.
- Sun morning: needed 1 = open 1 → "Last chance today". Trains Sunday → met.

**C. Safe, last chance, lost** (goal 4, only Mon and Tue done).
- Thu morning: needed 2, open 4 (Thu, Fri, Sat, Sun) → "2 more to go this week". This is the brief's "3 Mon–Sat days left, 2 needed, still safe".
- Sat morning (nothing Wed–Fri): needed 2, open 2 (Sat, Sun) → "Train today to stay on track". This is the brief's "1 Mon–Sat day left, 2 needed": at risk, not yet lost, because Sunday can fill in.
- No workout on Sat: at the end of Sat, needed 2 > 1 day left → **lost**. The streak becomes 0, Home says "Fresh start today", and the best streak is kept.
- Trains Sunday → "New streak: day 1".

**D. Counting across weeks** (goal 4). Week of the 5th: Mon, Tue, Thu, Sat and Sun trained (5 days, met). This week, Mon and Tue are trained and today is Wed the 14th.
- Streak = 5 + 2 = **7 days**. Weeks on track = **1** (this week isn't met yet).

**E. A week that ends short.** Continuing D, nothing else is trained this week. Ends of Wed, Thu and Fri are fine (2 needed, with 4, 3 and 2 days left). At the end of Sat, 2 are needed with 1 day left → lost.
- The streak drops from 7 to 0 and the best streak stays 7. Training on Mon the 19th gives "New streak: day 1".

**F. Goal change mid-streak.** The goal was 4 from Mon the 5th. On Wed the 14th it's lowered to 3, which stores `{2026-10-12, 3}`.
- The week of the 5th is still judged at 4; this week is judged at 3. With Mon and Tue done, "1 more to go this week".
- Changing it again this week replaces the entry for the 12th.

**G. Backfill and unmark** (goal 4). Mon, Tue, Thu and Sat were trained, but Thu and Sat were never ticked and have no sessions.
- At the end of Sat the app sees 2 done with 1 day left → lost, "Fresh start today".
- On Sunday the user ticks Thu and Sat in Plan. Recomputed: met, and the streak is back.
- Unticking them again ends it again.

**H. Year boundary.** Mon 29 Dec 2025 to Sun 4 Jan 2026 is one week, identified by 2025-12-29. Its goal is looked up by that date, and its workouts count together across the new year.

**I. Starting mid-week** (goal 4, first ever workout on Fri the 16th).
- At the end of Thu, 4 are needed with 3 days left, so the week is lost. That changes nothing, since there's no streak yet.
- Fri and Sat are trained → "New streak: day 2". From the week of the 19th, the goal applies normally.

### 4.6 StreakCalculator (pure Dart, `checkin/domain`)

- Interface: `abstract interface class StreakCalculator { StreakSnapshot compute(CheckInHistory history); }`
- Implementation: `WeeklyStreakCalculator(Clock clock)`.
- `StreakSnapshot` holds: `currentDays`, `bestDays`, `weeksOnTrack`, `CurrentWeek` (done, goal, needed, openDays, status), and per-week results for Stats.

Unit tests, all with a fixed clock:
- goals 3, 4, 5 and 6
- a leave day on each weekday Mon–Sat
- Sunday bonus filling a gap, and a Sunday-only week
- week rollover at the end of Sun and the start of Mon
- goal changes mid-streak, more than once in a week, and before the first workout
- backfilled and unmarked days, and a session-derived day overridden to not done
- DST weekends (2026-03-29 and 2026-10-25), with times near midnight
- the year boundary (examples H and a 53-week ISO year)
- every status line, plus the lost and new-streak transitions
- best streak kept after a reset, empty history, and future-dated notes that never count

---

## 5. XP, levels and badges

All values are constants in `features/rewards/domain/reward_rules.dart`.

| Source | XP |
|--------|----|
| Workout day (Sunday included) | +10 |
| That day also has a finished session with at least one completed working set | +10 more (once per day) |
| Personal record: a completed working set heavier than every earlier set **and** the baseline max of that exercise (the first-ever set of an exercise is not a PR; counted at most once per exercise per session) | +25 |
| Week met | +50 |

- **Levels:** reaching level L takes `50 × L × (L − 1)` total XP. That gives level 2 at 100, 3 at 300, 4 at 600, 5 at 1,000 and 10 at 4,500. At about 4 workouts a week (~150 XP), level 5 takes ~7 weeks and level 10 ~30 weeks. The XP bar shows "Level 4 · 120 XP to level 5".
- XP and level are **derived** from days, sessions and weeks, so they are always recomputed. Undoing a check-in removes its XP.

**Badges (13):**
- first workout
- streak 3, 7, 14, 30, 60 and 100 (best streak ever)
- first PR
- first full week (the first week that met its goal; see Q6)
- 10, 50 and 100 total workouts (workout days)

"Next badge" shows the locked badge closest to done, as "3 more workouts to earn 10 workouts". Earned badges are **kept once earned** (see Q2), with the date earned.

**Celebrations:**
- **When:** a check-in (flame pulse plus "Day 12"), level up, a new badge, a PR on the session summary, and the week goal met.
- **How:** at most one overlay per action, about 1.2 s, tap to dismiss, a light haptic, and at most 12 soft particles in ember, gold and coral. If several happen at once, one card lists them.
- **Reduce motion:** no particles or scale; a calm fade with a check.
- **On first launch after the update:** badges already deserved from existing history are recorded silently, so the app doesn't open with a flood of celebrations.

---

## 6. Schema change (version 1 → 2)

```json
{
  "schemaVersion": 2,
  "checkIns": {
    "days": {
      "2026-10-14": { "done": true, "note": "Chest + triceps", "time": "18:30", "durationMin": 60, "updatedAt": "2026-10-14T19:40:00+05:30" },
      "2026-10-16": { "done": null, "note": "Leg day, try heavier squats", "time": "07:00", "durationMin": null, "updatedAt": "…" }
    },
    "goalHistory": [ { "effectiveFrom": "2026-10-12", "daysPerWeek": 4 } ]
  },
  "rewards": {
    "earnedBadges": [ { "id": "streak_7", "earnedAt": "2026-10-14" } ],
    "lastCelebratedLevel": 3
  },
  "settings": {
    "…": "unchanged fields",
    "checkInReminder": { "isEnabled": false, "time": "19:00" }
  }
}
```

- **`days` is a map keyed by date**, so one entry per day is guaranteed by its structure.
- `done` can be `true`, `false` or `null`. `null` means you haven't set it, so sessions decide (4.1).
- **`source` is derived, not stored:** "session" when the Done state comes from a session. Storing it could drift when sessions are edited or deleted.
- `time` is local "HH:mm".
- **Validation:** note up to 120 characters, duration 1–600 minutes, and a future day can't have `done: true`.
- **`gymDaysPerWeek` has no separate settings field.** The current goal is the newest `goalHistory` entry, and the settings row reads and writes it. Keeping one source avoids two values disagreeing.
- **XP and level are not stored.** Only `lastCelebratedLevel` is kept, so a level-up is celebrated once.

**Migration v1 → v2** is pure, ordered and tested:
1. Add an empty `checkIns` (`days: {}`, `goalHistory: []`).
2. Add `rewards` (`earnedBadges: []`, `lastCelebratedLevel: null`).
3. Add `settings.checkInReminder` (off, 19:00).
4. Map `yearDots.colorPreset: "sage"` to `"ember"`.

Past sessions automatically count as workout days because of the 4.1 rule, so existing users start with their real streak.

**Backup:**
- `checkIns` and `rewards` are new feature-owned data sections, so the existing `DocumentSectionContributor` includes them in backups automatically.
- Old v1 backups migrate through the same pipeline on restore.
- The backup → wipe → restore round-trip test gains check-ins, a goal history and earned badges.
- New tests: a v1 data-file fixture and a v1 backup fixture, each migrated to v2.

---

## 7. Architecture

New features, following the existing pattern (each with a module, a public API file, a `_domain.dart` file and a README):

| Feature | Owns | Depends on |
|---------|------|------------|
| `checkin` | Days, goal history; `StreakCalculator`; Today card, day sheet, Plan tab | `workouts` (sessions, read-only) |
| `rewards` | Reward rules, level curve, badge catalogue, PR detection; earned badges; XpBar, BadgeTile, next-badge teaser, CelebrationOverlay controller | `checkin`, `workouts` |
| `stats` | Stats calculations (consistency, heatmap, time of day); Stats tab, Badges screen | `checkin`, `rewards`, `workouts`, `year_dots` |

Dependencies go one way only: workouts → checkin → rewards → stats and home. The architecture test enforces it.

Changes to existing features:
- `home` is rebuilt.
- `settings` becomes the Me tab (it uses `checkin` for the goal row).
- `exercises` and `year_dots` lose their tabs but keep their routes.
- `train` hosts the Exercises segment.
- `onboarding` gains the goal and all-set steps.

**Design system:**
- **New:** `ProgressRing` (determinate), `FlameIcon`, `StepIndicator`, `NumberChoiceChips`, `HeroCard`.
- **Updated:** `AppButton` (56 dp primary), `AppTextField` (warm focus), `AppCard` (soft shadow), `AppChip`.
- **Renamed:** the existing loading spinner `AppProgressRing` becomes `AppLoadingRing`, so the name `ProgressRing` can mean progress.

**Shared widgets:**
- **New:** `StreakCard`, `DayChip`, `WeekStrip` (replaces Home's private strip), `MonthCalendar`, `BadgeTile`, `XpBar`, `CelebrationOverlay`, `StatTile`.

All of these go into the catalogue, plus golden images.

**Reminder ("Ready for today?"):**
- Off by default, with a time setting (default 19:00).
- It schedules one-off local notifications for the next 7 Mon–Sat days that aren't done. The schedule is refreshed on app open and on every check-in, so a day you've already ticked never gets a reminder.
- If you don't open the app for a week, reminders stop: deliberately gentle.
- It uses the existing `NotificationGateway` and sends nothing anywhere.

Week calendars become Monday-first everywhere (amending D15), because the week definition is now fixed.

---

## 8. Build steps (I stop for review after each)

| Step | Delivers | Tests |
|------|----------|-------|
| a | New tokens and theme, display font, updated and new design-system components, catalogue entries | Contrast test on the new pairs, component goldens (light/dark, phone/tablet, 1× and 2× text), catalogue render test |
| b | Schema v2, migration, `checkin` domain and data, `StreakCalculator` | Migration and fixture tests, full streak test list (4.6), round-trip test extended |
| c | Today card, day sheet, Plan tab, session-derived days | Day sheet rules (future, past, override), Plan widget and golden tests |
| d | Home redesign, the new tab set, Train segments | App flow tests updated (5 tabs, 2-tap paths), Home goldens |
| e | Onboarding restyle, goal step, all-set screen | Gate tests (validation, draft, restore path, skip keeps the default goal), goldens |
| f | Stats tab, Badges screen, "Your year" card | Stats calculations, empty states, goldens |
| g | XP, levels, badges, celebrations, silent first-run backfill | Reward rules, PR detection, badge earning and keeping, celebration queue, reduce-motion goldens |
| h | Me: goal and reminder rows, reminder scheduling, accessibility and polish pass | Reminder scheduling with a fake gateway, 200% text, landscape and semantics checks, integration test updated |

---

## 9. Risks and open questions

Each question has my recommended default. I'll build with these unless you say otherwise.

| # | Question | Default |
|---|----------|---------|
| **Q1** | **Restarting inside a lost week (4.3 rule 5).** Your brief says the next workout starts day 1, but also that a week ending below goal ends the streak. Applied literally, a new streak started on a lost week's Friday would be ended again by that same week. | That week is never checked again, so the new streak survives into next week. This also lets new users start a streak mid-week. |
| **Q2** | **Should badges be kept once earned?** Fully derived badges could disappear if days are unmarked, which feels like a punishment. | Keep them once earned (`earnedBadges`). Streak, XP and level stay derived. |
| **Q3** | **"Optional soft sound".** It needs an audio package and a licensed sound file. | Haptics only for now. Sound can be added later as a setting that's off by default. |
| **Q4** | **Button colour.** `#F26B2D` fails AA with white text. | Buttons use `#C2410C`; `#F26B2D` is kept for the flame, rings and fills (2.1). |
| **Q5** | **Tabs.** | Home, Plan, Train, Stats, Me, with Exercises in Train, Year Dots in Stats and Settings in Me (3.1). |
| **Q6** | **"First full week".** | The first week that met its goal (not "trained all six days"). |

Other ambiguities, resolved with the simplest option (they go into `docs/decisions.md` on approval):

1. **Where the streak rules are.** The brief says "streak rules (Section 3)"; they're in its Section 4. This plan covers both 3 and 4.
2. **Sessions mark days automatically by derivation, not by writing entries.** Deleting or backdating a session updates the day by itself; your explicit Done or not-Done always wins (4.1).
3. **`gymDaysPerWeek` lives only in `goalHistory`** (6).
4. **XP for "session logged with sets"** counts once per day, not per session, so it can't be farmed.
5. **"Last chance today" can fall on a Sunday** when Sunday is the only day left that could still make the goal (example B). Sunday is never required, but it can rescue a week.
6. **Changing the goal can rescue the current week**, since it applies from this Monday. It's a personal tool, so this is allowed.
7. **Future days get a note and planned time only**, no duration, as the brief says.
8. **The base spec's out-of-scope list** (per-day notes, gentle streaks only) is amended by this brief. The no-shaming rule is kept through the copy rules.
9. **Year Dots highlighting trained days** (optional in the brief) is **not planned**. It would need a fourth dot state in Dart, Kotlin and the shared test vectors, so it isn't cheap.
10. **The Home "last session" summary moves to Train**, to keep Home focused.

**Risks:**
- **Display font:** Bricolage Grotesque might lack something we need (tabular figures or glyph coverage). I check before step a; the fallback is Outfit.
- **Hero number at 200% text** is capped at 1.5× to avoid overflow; screen readers get the full label.
- **Notifications on Android 13+** need permission (asked only when you turn the reminder on). Inexact scheduling can be a few minutes late.
- **Golden images will all change** with the new palette. I'll regenerate them deliberately in step a, not mix them with logic changes.
- **Tab change:** existing users will find Exercises and Year Dots in new places.
- **Fixed Sunday rest day.** Some people rest on Friday or Saturday. That's out of scope (see P3).

---

## 10. Proposals (not built without your approval)

- **P1. A "Back at it" badge** for the first workout after a fresh start: a positive frame for coming back.
- **P2. Monday recap card** on Home, dismissible: "Last week: 4 of 4. Goal met." Or, after a short week: "Last week: 2 workouts. New week, fresh start."
- **P3. Choose your rest day** (default Sunday) in Me. The streak rules already treat the rest day as one parameter, so this would be a small change later.
- **P4. Year Dots in-app highlight** of trained days, in the app only (not the wallpaper), if you want it later.
- **P5. Celebration sound**, off by default, if you approve a small audio dependency.
