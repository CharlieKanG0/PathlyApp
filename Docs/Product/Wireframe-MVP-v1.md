# PATHLY AI Coach — MVP Wireframe Flows

This document outlines wireframe-style user flows for designers to use as a visual starting point. Each flow is presented step-by-step with suggested screen states.

---

## Flow 1: Onboarding & Baseline Run

**Screen 1: Welcome**

* Headline: "Meet your new AI Coach"
* CTA: "Get Started"

**Screen 2: Permissions**

* Request: HealthKit, Notifications
* Clear explanation why needed
* CTA: "Allow"

**Screen 3: Baseline Run Intro**

* Text: "First, let's do a 30-min run to understand your fitness level."
* CTA: "Start Baseline Run"

**Screen 4: Watch Run Session**

* Live metrics: time, distance, pace, HR
* Audio cues: warmup, halfway, cooldown
* Pause/End controls

**Screen 5: Baseline Run Summary**

* Stats: time, distance, avg pace, HR avg
* CTA: "Continue"

**Screen 6: Goal Selection**

* Question: "What’s your focus?"
* Options: \[Run Faster] \[Run Longer]
* CTA: "Generate Plan"

**Screen 7: Plan Overview**

* Simple 4-week calendar
* 3 runs/week marked (easy, interval, long)
* CTA: "Done"

---

## Flow 2: Daily Check-in & Adaptation

**Screen 1: Daily Prompt**

* Question: "How are you feeling today?"
* Mood buttons: 😫 / 😐 / 😄

**Screen 2: Adaptation Result**

* Example: "Today: Recovery Run, 20 min"
* Subtext: "Adapted due to low readiness."
* CTA: "Send to Watch"

---

## Flow 3: Workout Session (WatchOS)

**Screen 1: Pre-run**

* Display workout type + duration
* Button: "Start Run"

**Screen 2: Active Run**

* Metrics: HR, elapsed time, distance, pace
* Audio guidance triggered at workout stages
* Controls: pause/resume, end

**Screen 3: Post-run Reflection**

* Prompt: "How did that feel?"
* Mood buttons: 😫 / 😐 / 😄

**Screen 4: Run Summary**

* Stats: distance, time, avg pace, avg HR
* CTA: "Finish"

---

## Flow 4: Weekly Review & Milestones (iOS)

**Screen 1: Weekly Plan View**

* Week calendar layout
* Each day’s planned/adapted run
* Highlight completed runs

**Screen 2: Run History**

* List of past runs with key stats

**Screen 3: Milestone Popup**

* Example: "🎉 Congrats! Week 1 complete!"
* CTA: "Keep Going"

---

### Notes for Design Team

* Style: Clean, minimal, bold typography, simple iconography.
* Tone: Friendly, motivational, approachable.
* Accessibility: Large touch targets, high contrast, haptics on watch interactions.
* Ensure **consistency** between iOS and watchOS UI while optimizing for platform form factors.
