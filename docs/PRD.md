# Martial Body — Product Requirements Document

## 1. Executive Summary

Martial Body is a fully offline Flutter app that delivers a single, fixed 24-week training program to one type of user: someone unfit, likely overweight, starting from zero, who wants to be physically ready to walk into an MMA gym.

This is not a generic fitness app. There is no exercise library, no custom routine builder, no social features, no cloud sync. The program is the product. Every design decision flows from the specific logic of the 24-week plan — its phases, its deload weeks, its progression from steady-state cardio to sprint intervals to shadowboxing, its obsessive attention to joint health.

The app has one job: make it trivially easy to follow the program exactly as written, day after day, for 24 weeks.

---

## 2. Target User

**Primary persona: "Zero-to-MMA"**

- Male or female, 25–45, sedentary job
- Overweight or significantly deconditioned
- Has decided to start MMA but knows they aren't physically ready
- May have existing issues: left shoulder instability, tight hips, poor ankle mobility
- No gym experience or experience that has lapsed for years
- High motivation but will lose it without structure and visible progress
- Does NOT want to think — they want to be told exactly what to do

**What they fear:** Getting to the gym and being embarrassed by their fitness level. Injury. Not knowing if they're doing it right.

**What they need:** A trusted guide that says "do this today, rest tomorrow, here's why, you're on track."

---

## 3. Core Product Principles

1. **The program is the authority.** No user can modify exercises, change the order, or skip blocks without explicit acknowledgment. The app does not offer alternatives or let the user build their own routine.

2. **One session at a time.** The user opens the app and sees exactly what to do today. Nothing more. The full 24-week calendar exists but is secondary — the daily session is primary.

3. **Guided, not just displayed.** Showing a list of exercises is not enough. The app walks the user through each block, each set, each rest period. It functions like a coach standing next to them.

4. **Deloads are non-negotiable.** Weeks 4, 10, 16, and 20 are deload weeks. The app must communicate this clearly and not let users accidentally treat them as normal training weeks.

5. **Left shoulder protocol.** Phase 1 includes specific warnings about the left shoulder. The app must surface these warnings at relevant exercises — not buried in notes.

6. **Progress is earned, not fabricated.** No fake streaks, no hollow badges. Progress is: sessions completed, weeks done, phases passed. The app shows the real number.

7. **Zero friction to start.** Opening the app → tapping Start Session must take under 3 taps. Any friction in the daily flow is failure.

---

## 4. Program Structure Reference

| Phase | Weeks | Days/Week | Intensity | Deload Weeks | Cardio Style |
|-------|-------|-----------|-----------|--------------|--------------|
| 1 — Foundation | 1–6 | 5 (Mon–Fri) | 60–70% | Week 4 | Steady-state 20–35min |
| 2 — Engine Build | 7–12 | 5 (Mon–Fri) | 75–80% | Week 10 | Intervals begin Wk 7 |
| 3 — Full Combat | 13–20 | 5 (Mon–Fri) | 85–90% | Wks 16 & 20 | 8×15s ALL OUT sprints |
| 4 — MMA Transition | 21–24 | 4 (Mon/Tue/Wed/Fri) | 85% | — | Sprints maintained |

**Deload weeks:** All volume reduced 40–50%. Intensity maintained. App must auto-detect and apply.

**Phase 4 volume reduction:**
- Weeks 21–22: −30% sets
- Week 23: −40% sets + shadowboxing 15min Tue/Fri
- Week 24: −50% sets + shadowboxing daily

**Session structure (every session):**
1. WARMUP block (10–15 min)
2. MAIN / MAIN COMBAT BLOCK
3. Day-specific special blocks: TENDON & ARMOR, POSTERIOR CHAIN, CONDITIONING, GRIP & FOREARM, CORE & PELVIC FLOOR
4. CARDIO FINISHER (Phase 1) or inline CONDITIONING block (Phase 2+)
5. FINISHING CIRCUIT (Fridays, Phase 2+): 3 rounds, no rest within round, 90s between rounds
6. COOLDOWN (static stretches — listed but not timed by default)

---

## 5. Screen Structure & UX Rationale

### 5.1 Onboarding (first launch only)

**What it shows:** A brief explanation of the 24-week journey and a date picker for the program start date.

**Why:** The entire session scheduling logic depends on `program_start_date`. Without this, the app cannot determine what week the user is on and what session to show today. The date picker defaults to today. Users who started training before installing the app can backdate.

**Onboarding screens:**
1. Welcome — "6 months from now, you walk into your first MMA class ready." One screen. One button: Start the Program.
2. Date Selector — "When did you start Week 1?" (default: today). Confirm.
3. Brief program overview — 4 cards showing Phase 1 → 2 → 3 → 4 with week ranges and one-line descriptions.
4. Done — go directly to Home.

No account creation. No email. No sync setup. Three screens and you're in.

---

### 5.2 Home Screen (primary screen)

**Primary action:** Show today's session and make it one tap to start.

**Layout:**
- **Top:** Week number (e.g., "Week 3 of 24") + Phase badge ("Phase 1 — Foundation")
- **Center — Today's Session Card:** Large card showing session name (e.g., "Monday — Lower Body Mobility + Strength"), duration estimate (70–90 min), and a START button
- **If deload week:** The card shows a "DELOAD WEEK" banner in amber — volume is reduced, intensity maintained
- **If rest day (Thursday in Phase 4, or weekend):** Shows "Rest Day" with a recovery tip from the program
- **Bottom section:** Progress strip — "X of 5 sessions this week complete" + "X weeks done"

**Phase transition moment:** When the user completes Week 6 and opens the app on what is now Week 7, the home screen shows a full-screen phase transition card before the normal home view: "You've completed Phase 1. Phase 2 begins today." This is a significant moment and deserves prominent treatment.

**Why this design:**
- Program has 5 sessions/week (or 4 in Phase 4). User needs to know immediately: is today a training day? What is today?
- Deload is a specific program feature, not an optional recovery — it must be surfaced automatically
- Phase transitions are milestones; they need ceremony

---

### 5.3 Session Overview Screen

**What it shows:** The full session before the user starts it — all blocks in order with all exercises listed.

**Why:** The user needs to know what they're getting into. A 70–90 minute session with 6 blocks needs a map. This screen functions as the pre-session brief.

**Layout:**
- Session name and phase/week context at top
- Scrollable list of blocks, each as a collapsible card:
  - Block name + type icon (warmup, strength, conditioning, etc.)
  - Exercise list with sets × reps and tempo notation
  - "NEW" badge on exercises appearing for first time in this phase
- Duration estimate per block
- Cardio finisher block (Phase 1: "25 min steady-state" / Phase 2+: show interval protocol)
- Cooldown block (listed, not interactive)
- Large "START SESSION" button at bottom

**Left shoulder warning:** On Phase 1 Tuesday sessions, a yellow warning banner appears below the session header: "LEFT SHOULDER PROTOCOL ACTIVE — Stop immediately if any discomfort during pressing exercises. Replace bilateral press with single-arm DB press."

**Interval protocol display:** Phase 2 Wednesday and all Phase 3 conditioning blocks must show the specific protocol:
- Phase 2 Wks 7–8: "6 rounds × 20s ALL OUT / 40s walk"
- Phase 2 Wks 9–10: "8 rounds × 20s ALL OUT / 40s walk"
- Phase 2 Wks 11–12: "8 rounds × 20s ALL OUT / 35s walk"
- Phase 3+: "8 rounds × 15s ALL OUT / 45s active recovery"

---

### 5.4 Active Session Screen (core experience)

**What it shows:** One exercise at a time, in block order. The user works through the session like a queue.

**Session navigation:**
- Progress bar at top: blocks as segments (warmup | main | tendon | cardio | cooldown)
- Current block name and exercise number within block (e.g., "MAIN BLOCK — Exercise 3 of 6")
- Exercise card (large, centered)

**Exercise card contains:**
- Exercise name (large)
- "NEW" badge if first appearance in this phase
- Sets × Reps: "3 sets × 8/leg"
- Tempo: "3-1-1-0" displayed as four labeled values: Eccentric (3s) · Pause (1s) · Concentric (1s) · Pause (0s) — with a simple visual diagram
- Rest: "90s between sets"
- Coaching notes (from program — shown in collapsible panel)
- Set tracker: row of dots or checkboxes for each set — user taps to mark complete
- Rest timer: activates automatically after marking a set complete, counts down rest period
- "Log weight" button (optional, can be skipped — weight tracking is encouraged but not required)

**Tempo explanation:** The 4-part tempo notation is not obvious to a beginner. First time any exercise with a tempo is shown, a one-time tooltip explains it: "Read as: Lower for 3s · Pause 1s · Lift for 1s · Pause 0s." After that, the four numbers are shown compactly.

**Cardio/conditioning blocks:**
- LISS (Phase 1): Shows duration + target HR range ("25 min, conversational pace, 60–65% max HR") + a simple timer
- Intervals (Phase 2+): Shows interval protocol card with a round-by-round timer:
  - Round counter (1/6, 2/6, etc.)
  - Work timer (20s countdown, color = red)
  - Rest timer (40s countdown, color = green)
  - Auto-advances through rounds
  - Manual skip available

**Finishing circuit (Fri, Phase 2+):**
- Shows as a special block: "3 ROUNDS — No rest within round · 90s between rounds"
- Lists 4 exercises inline
- Within-round timer counts the circuit duration
- Between-round 90s rest timer auto-starts

**Cooldown:**
- Listed as a checklist, not guided
- User taps each stretch as done
- Duration note shown (e.g., "2 min/side")
- No timer — cooldown is self-paced

**Completing a session:**
- After last cooldown item, "Complete Session" button appears
- Tapping records the session as done for today + current week
- Shows a brief completion summary: time elapsed, blocks completed, exercises done
- Confetti or minimal celebration — not overdone
- Returns to Home

---

### 5.5 Progress Screen

**What it shows:** Local progress — no server, no account.

**Sections:**
1. **Current status:** Week X of 24 · Phase Y · X sessions completed total
2. **This week:** Which sessions done (Mon/Tue/Wed/Thu/Fri — each with tick or empty), completion percentage
3. **Phase completion:** Progress bar per phase (Phase 1: 6 weeks = 30 sessions possible)
4. **Session history:** Scrollable log of past sessions — date, session name, duration, completed/incomplete
5. **Streak:** Consecutive weeks with ≥ 3 sessions completed (achievable target, not perfectionistic)

**What it does NOT show:** Body weight charts, calorie counts, heart rate data. This app tracks training completion, not biometrics.

---

### 5.6 Program Screen (24-week calendar)

**What it shows:** All 24 weeks laid out, grouped by phase, so the user can see the full journey.

**Layout:**
- Phase tabs or sections at top: PHASE 1 · PHASE 2 · PHASE 3 · PHASE 4
- Within each phase: week rows (Week 1, Week 2, … Week 6 for Phase 1)
- Deload weeks highlighted in amber
- Each week row shows Mon–Fri (or Mon/Tue/Wed/Fri for Phase 4) with session names abbreviated
- Completed sessions shown with checkmarks
- Current week highlighted
- Future weeks visible but dimmed

**Phase 4 visual difference:** The Thursday column is visually absent — 4 columns instead of 5.

**Why this screen exists:** The user needs to see the full arc. Knowing "in 4 weeks I enter Phase 3 where sprint intervals start" is motivating. The calendar makes the journey concrete and finite.

---

## 6. Session Scheduling Logic

Given `program_start_date` and today's date:

```
current_week = floor((today - program_start_date).inDays / 7) + 1
current_phase = lookup(current_week)  // 1-6→P1, 7-12→P2, 13-20→P3, 21-24→P4
day_of_week = today.weekday  // 1=Mon, 5=Fri
is_deload = current_week in [4, 10, 16, 20]
is_training_day = day_of_week in valid_days_for_phase(current_phase)
```

Phase 4 valid training days: Monday (1), Tuesday (2), Wednesday (3), Friday (5) — no Thursday.

If today is not a training day → Home shows Rest Day.
If today IS a training day → look up session for (current_phase, day_of_week).

---

## 7. Deload Week Behavior

Deload weeks (4, 10, 16, 20) reduce ALL volume by 40–50% while maintaining intensity (load on the bar stays the same).

Implementation: When `is_deload == true`, all `block_exercises.sets` values are multiplied by 0.6 (round down, minimum 1). The app does NOT change reps or weight. The session structure is identical; only set counts drop.

UI: The Active Session screen shows sets as "[2 sets]" instead of the normal "[3 sets]" — with a small "DELOAD" tag to explain. The SessionOverview also shows reduced set counts with the deload banner visible.

---

## 8. Phase 4 Volume Reduction

Phase 4 applies progressive weekly volume reduction on top of the base Phase 3 sessions:
- Weeks 21–22: multiply set counts by 0.7 (−30%)
- Week 23: multiply set counts by 0.6 (−40%) + shadowboxing 15min on Tue/Fri
- Week 24: multiply set counts by 0.5 (−50%) + shadowboxing on all 4 days

The app renders the reduced set count. Shadowboxing appears as a special exercise block added to relevant sessions from Week 23 onward.

---

## 9. Onboarding & First Run

1. Splash → Welcome screen (one-time only)
2. Date picker: "Set your program start date" (default: today)
3. Phase overview cards (swipeable, skippable)
4. Home screen with Week 1, Day 1

If user opens the app more than 24 weeks after start date: show "Program Complete" screen with summary stats and a prompt to reset or start again.

---

## 10. Out of Scope (Explicit)

- **No custom routines.** Users cannot add, remove, or reorder exercises.
- **No exercise video/GIF library.** Coaching notes are text only.
- **No nutrition tracking.** The program mentions diet ("structured diet begins") but this app does not track calories or macros.
- **No body weight / measurement logging.** Progress = sessions completed.
- **No social features.** No sharing, no leaderboards.
- **No notifications / push alerts.** F-Droid compatible — no FCM.
- **No cloud backup.** Local SQLite only.
- **No injury reporting or substitutions.** The shoulder protocol is baked in as a warning, not an interactive substitution engine.
- **No premium tier.** One app, one program, free on F-Droid.
- **No settings screen** beyond resetting the program start date.
