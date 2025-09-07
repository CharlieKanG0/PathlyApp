# PATHLY AI Coach — MVP Product Requirements Document (PRD)

---

## 1. Problem Statement

Most recreational runners follow generic, static training plans (from books, PDFs, or free apps) that fail to account for their fitness level, recovery, and motivation. This leads to burnout, injury, or dropping out. Existing apps like Nike Run Club or Strava either provide static plans or focus on social features, not adaptive coaching.

**Opportunity:** Deliver a simple but adaptive coaching loop that feels personal: check in daily, get a workout tailored to how you feel, and receive in-run guidance. Start with a lightweight MVP to validate engagement before investing in full-scale personalization.

---

## 2. Goals

**Primary Goals (MVP)**

* Validate that runners value a **daily adaptive coaching loop**.
* Create a **baseline-first onboarding** to personalize plans.
* Prove that **in-run guidance** (via audio cues) increases engagement and completion rates.
* Ensure a **stable, low-friction experience** on iOS + watchOS.

**Non-Goals (MVP)**

* No custom AI/ML training models.
* No social/community features.
* No complex integrations (Garmin, Strava, etc.).
* No background/anonymous data uploads — data stays on-device.

---

## 3. Target Audience

* **Goal-Oriented Runners**: Beginners to intermediates with a concrete goal (e.g., finish a 5K, run longer distances, or improve pace).
* Motivated but not experts; they need guidance and encouragement, not deep analytics.

---

## 4. User Journeys

**Day 0 — First Use / Baseline**

1. User installs app, accepts HealthKit & notifications.
2. Prompt: “Let’s do a 30-min baseline run to see where you’re at.”
3. Watch guides user through 30-min baseline run (generic encouragement).
4. Post-run → summary shown (time, distance, pace, HR if available).
5. App asks: “Do you want to run faster or longer?”
6. Generates a **4-week plan** (3 runs/week) tailored to baseline + goal.

**Day 1 — First Planned Workout**

1. App prompts daily readiness check-in (😫 / 😐 / 😄).
2. Displays adapted workout (“Today: Easy Run 20 min”).
3. User sends workout to watch + starts session.
4. Audio cues guide workout; music ducks correctly.
5. Run saved to Health + summary shown in app.

**Day 2 — Low Readiness Day**

1. User checks in 😫.
2. Plan adapts: “Intervals swapped to recovery jog.”
3. Run saved; reflection asked post-run (“How did that feel?”).

**Week 1 End**

1. App shows history of runs.
2. Milestone: “Nice — you’ve finished Week 1!”

**Week 4 End**

1. App congratulates user for completing their plan.
2. Prompts new goal (faster vs longer) and generates new 4-week plan.

---

## 5. Key Features

### Onboarding & Baseline

* 30-min guided baseline run.
* Post-run goal selection: **Faster** vs **Longer**.
* Auto-generate simple 4-week plan (3 runs/week).

### Daily Readiness Check-in

* Prompt: “How are you feeling today?” (😫 / 😐 / 😄).
* Optional (future): RPE, sleep hours, soreness.
* Deterministic adaptation of daily workout + “reason for change.”

### Adaptive Plan Logic (Rules-Based)

* 😫 → downgrade workout (interval → recovery jog, shorter duration).
* 😐 → run as scheduled.
* 😄 → run as scheduled, motivational message.
* Weekly plan remains stable; only today adapts.

### Workout Session (WatchOS)

* Start/pause/stop workout.
* Track: time, distance, pace, HR.
* Audio cues:

  * Warmup/start.
  * Intervals/recovery.
  * Cooldown.
  * Motivational encouragement.
* Music ducking (not stopping) for cues.

### Post-run Reflection & Save

* Prompt: “How did that feel?” (😫 / 😐 / 😄).
* Save run to Apple Health.
* Summary in app (time, distance, pace, HR avg).

### iOS Companion App

* Weekly plan overview.
* Daily adapted workout card.
* History of runs (basic stats only).
* Simple milestone celebrations (week completion, plan finish).

### Data Scope

* Data stored locally + Apple Health.
* No background or cloud uploads in MVP.
* Watch ↔ iPhone sync via WCSession only.

---

## 6. Success Metrics (MVP)

* **Activation**: % of new users who complete baseline run + select a goal (target: 70%).
* **Engagement**: Average runs/week per active user (target: ≥2 runs/week).
* **Retention**: % completing 4-week plan (target: 25–30%).
* **Satisfaction**: Post-run reflection positive (😐 or 😄) ≥ 70% of the time.
* **Stability**: Crash-free sessions > 98%.

---

## 7. Constraints & Risks

* **Engineering**: Battery drain on watch if GPS/HR not optimized.
* **Audio UX**: Must coexist seamlessly with music apps.
* **Adoption**: Runners may skip baseline run; must frame it as fun/essential.
* **Data richness**: Minimal readiness inputs may limit perceived adaptiveness.
* **Compliance**: Must avoid medical/injury prevention claims in App Store copy.

---

## 8. Open Questions

* Should baseline run be mandatory, or can users skip? (MVP assumes mandatory.)
* Should plan regenerate if multiple days are missed? (Out of scope for MVP.)
* Monetization: free only at MVP, premium paywall introduced later.

---

## 9. Next Steps

1. Finalize UX flow for baseline run + goal selection.
2. Lock content for audio prompts (scripted voice lines + TTS fallback).
3. Engineering spike: HKWorkoutSession reliability, audio ducking, WCSession sync.
4. Design deliverables: iOS daily check-in, plan overview, watch workout UI.
5. Build TestFlight MVP with \~10–20 pilot users.
