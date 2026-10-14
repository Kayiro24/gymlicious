# Gym Tracker: UI and feature upgrade brief (2026-10-14)

> Received from the product owner on 2026-10-14. It builds on `docs/requirements.md`, which still defines the architecture, data layer, backup/restore, offline behaviour, testing rules and code conventions. Where this brief conflicts with it (mainly Section 7 "Soft Minimalism" and the sage palette), this brief wins. The plan for it is `docs/ui-upgrade-plan.md`.

---

## 1. Goal

Existing features keep working exactly as they do now. The UI becomes gamified and warm, with one new feature: a one-tap daily "Did you work out today?" check-in with a streak.

The app should feel rewarding and make people want to open it every day. It must stay so simple that anyone can use every feature without instructions. It must still look beautiful and premium, not like a cheap kids' game: no cartoon clutter, no neon, no confetti spam.

It is a personal, minimalist tool for daily use. Nothing to buy or sell, no ads, no social features, no accounts.

## 2. Visual direction

**Warm palette.** Replace the sage/soft-minimal tokens in design-tokens/tokens.json and regenerate the theme. Do not hard-code colours anywhere.
- Primary accent: ember orange (around #F26B2D)
- Secondary: amber/gold (around #F5A524), used for streaks, XP and rewards
- Highlight: warm coral/rose for celebrations and personal records
- Light background: warm cream (around #FFF7EE)
- Dark background: deep warm brown-charcoal (around #1F1612), never pure black
- Dark mode is warm too
- Verify WCAG AA contrast (4.5:1) for all text and adjust the tokens if needed

**Feel:**
- Rounded cards with soft shadows
- Generous spacing
- One bold, friendly display font for numbers and headings (bundled) plus one clean body font
- Big streak numbers
- A flame icon that grows or glows with the streak length (a few tiers, kept tasteful)
- Subtle gradients are fine; keep them restrained

**Simplicity rules (apply to every screen):**
- One obvious primary action per screen, a big and high-contrast button
- Plain words only, no jargon
- Minimum 48dp tap targets
- Icons always paired with a text label
- Any common action takes 2 taps or fewer
- Every screen needs a friendly empty state and a clear back path

**Gamification, subtle and positive:**
- Streak flame with a pulse animation when it increases
- Weekly progress ring ("3 of 4 days")
- XP and levels with a small progress bar. Suggested XP: workout check-in +10, session logged with sets +10 more, new personal record +25, weekly goal hit +50. Make the values constants in one file.
- A small set of badges and milestones: first workout, 3/7/14/30/60/100-day streaks, first PR, first full week, 10/50/100 total workouts
- A short celebration moment when the user checks in, hits a PR, earns a badge or levels up. Keep it to a brief animation, light haptics, and an optional soft sound.
- Respect reduce-motion with calm fallbacks
- Positive, encouraging copy always. Never guilt-trip or shame a missed day ("Fresh start today" instead of "You broke your streak").
- Do not add dark patterns such as fake urgency, countdown pressure or purchase prompts.

## 3. The daily check-in (the new core feature)

It is a to-do with one fixed item per day: "Did you work out today?" There are no custom tasks.

**Per day, the user can:**
- Tap one big button to mark the workout Done. Tapping again undoes it.
- Add an optional description (e.g. "Chest + triceps", "Rest and stretching", "Leg day, try heavier squats")
- Add an optional time (e.g. 6:30 PM) and an optional duration
- Do all of this for past days (backfill), today, and future days. For future days the user can only add or edit the description or planned time, not mark Done. Past days can be marked or unmarked.

**Where it lives:**
- Home page: a prominent "Today" card with the Done button, the streak and the weekly ring
- A simple Calendar/Plan screen: a week strip on top and a month view below. Each day shows a state: done, missed, rest/off, planned (has a description), future. Tapping a day opens a small bottom sheet with the Done toggle, description, time and duration.
- If a gym session was finished that day (from the existing workout logger), auto-mark that day Done, using the session start time as the time. The user can still edit it.

**Analytics:**
- Optional and not forced on the user: a collapsible "Stats" section or a separate "Stats" screen reached by one clear button
- Show: current streak, best streak, total workouts, this week and this month completion, a consistency percentage, a simple month heatmap, and typical workout time of day if times were entered
- Charts via fl_chart, in warm colours, with plain labels
- Handle the empty state gracefully

## 4. Streak and weekly-goal rules

**Settings → "Gym days per week":**
- A simple stepper or chips from 1 to 6, default 4
- Sunday is the built-in rest day. It is never required and never breaks a streak. If the user trains on a Sunday, it counts as a bonus: it adds to totals and XP, and can fill in for a missed day in that week.
- The user may train any days of the week (Mon–Sat). The goal is a number of days, not specific weekdays.

**Week definition:** Monday to Saturday, with Sunday as a bonus day (use the local calendar date, never 24-hour arithmetic).

**A week is "met" when done-days >= the weekly goal.**

**Streak:**
- Show it in days of consistent gym going ("12-day streak") as the headline number, plus "weeks on track" as a secondary number.
- Which days count toward the streak: workout days that belong to an unbroken chain of weeks, where each completed week met its goal.
- Skipped days never break the streak by themselves. Example: goal is 4, and the user trains Mon, Tue, Thu, Sat and skips Wed and Fri. The week is met, so the streak continues. The same applies if the user took 3 leave days in a goal-4 week and trained the other 3 plus a Sunday bonus.
- The current, unfinished week never breaks the streak early. It only breaks when reaching the goal becomes impossible. For example, with goal 4, if only 3 Mon–Sat days remain and 2 workouts are still needed, the week is still safe. If only 1 day remains and 2 are needed, it is "at risk" or "lost".
- Show the state on Home with a friendly status line: "On track", "1 more to go this week", "Last chance today", or "Fresh start".
- A week that ends below its goal ends the streak. After that, the next workout starts a new streak at day 1 (positive wording, and "best streak" remains visible).
- Changing the weekly goal in settings applies from the current week forward. Past weeks are evaluated using the goal that was active at that time, so store a small goal-history list (effectiveFrom + days).

**Because the rules above need judgment calls, write them as pure, deterministic Dart functions with no UI dependency, inject the Clock, and put them behind a StreakCalculator interface. Write thorough unit tests:**
- goal 3, 4, 5 and 6
- a leave day on each weekday
- Sunday bonus
- week rollover
- goal change mid-streak
- backfilled and unmarked days
- a DST change
- year boundary
- at-risk and lost states

Record any assumption you make in docs/decisions.md.

## 5. Home page (redesign)

Top to bottom:
1. Greeting with the user's name and avatar (opens Profile). Keep the quote card, restyled warm, but compact.
2. A large hero streak card: flame, big streak number, weekly progress ring, status line, XP/level bar
3. The "Today" card: one big "I worked out today" button. After tapping it shows a celebration, the Done state, and a quick "add note / time" affordance. If a workout is planned for today (from the active split's "up next" day), show a secondary "Start workout" button that opens the existing logger.
4. A mini week strip (Mon–Sat plus Sunday) showing the state of each day
5. A small "Next badge" teaser
6. Entry points to Stats and Plan/Calendar

Keep the bottom navigation short and clear, with labelled icons. Suggested: Home, Plan (calendar), Train, Stats, Me. Keep the existing Year Dots feature reachable (a tab or via Stats). If tabs are tight, tell me your recommendation in the plan.

Optional: allow Year Dots to highlight days the user trained, using the check-in data. Mark this as optional in the plan and do not build it unless it is cheap.

## 6. First-launch page and onboarding (make it beautiful)

Restyle the existing first-launch details gate and its optional steps with the same warm gamified look:
- A friendly welcome hero with a warm gradient and a simple illustration or icon
- A big, clear heading, and a short line that the data stays on this device
- Beautiful form fields: rounded, large, with warm focus states, segmented gender chips, and a polished profile photo picker with an initials avatar placeholder
- A step progress indicator across onboarding steps
- A new, simple step: "How many days a week do you want to train?" using big tappable number chips (default 4), and a note that Sunday is a rest day. Save it as the weekly goal.
- Keep the Restore from backup button at the top, tidy and visible
- Keep the same validation rules, draft persistence and skippable steps as before
- End with a short "You're all set" celebration that lands on Home

## 7. Data, backup and architecture (follow the old spec)

- Add the new data to the schema and bump schemaVersion with a tested migration. Suggested shapes: dailyEntries (date, done, description, time, durationMin, source), weeklyGoalHistory, xp/level state, and earnedBadges. Settings include gymDaysPerWeek.
- Check-ins are stored per local calendar date (YYYY-MM-DD) and are unique per day.
- Streaks, levels and badges are derived from stored entries wherever possible so they can never drift. Cache only what is expensive.
- Register a BackupContributor for the new data, and extend the backup → wipe → restore round-trip test to cover it.
- Keep the feature-first clean architecture, Riverpod, DI, typed Failures, and the minimal-comments rule.
- The new UI uses the shared design-system and shared widgets, and tokens only. Extend the widget catalogue with the new components (StreakCard, ProgressRing, DayChip, WeekStrip, BadgeTile, CelebrationOverlay, XpBar).
- Optional local reminder notification ("Ready for today?"), off by default, toggled in Settings. It is all on-device and sends nothing anywhere. Add a reminder-time setting only if cheap.
- Still no user data leaves the device, no analytics, no accounts.
- Stay responsive on phone and tablet, portrait and landscape, light and dark, and at 200% text scale. Cover loading, empty and error states, and update golden tests.

## 8. How to work

1. Write docs/ui-upgrade-plan.md first (see the top) and wait for my approval.
2. Then build in this order, stopping after each step for review:
   (a) tokens, theme and design-system components
   (b) data model, migration, StreakCalculator with tests
   (c) daily check-in and Plan screen
   (d) Home redesign
   (e) first-launch/onboarding restyle
   (f) Stats
   (g) XP, badges and celebrations
   (h) settings (gym days per week, reminder), accessibility and polish
3. If something is unclear, choose the simplest option and log it in docs/decisions.md.
4. Where you see a clearly better idea that keeps things simple and warm, propose it in the plan. Do not build it without approval.
