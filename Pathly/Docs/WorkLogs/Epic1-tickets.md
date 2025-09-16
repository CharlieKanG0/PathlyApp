# **Jira Tickets: The Forgiving Runner MVP**

This document contains detailed ticket breakdowns for each user story required to build the MVP.

### **Ticket: TFR-1 | Build the 3-Question User Onboarding Flow**

* **Epic:** New User Onboarding & Plan Generation  
* **Goal:** To capture the essential user inputs (Goal, Frequency, Experience) needed to generate a personalized running plan.  
* **Description:** As a new user, I want to answer three simple multiple-choice questions so that the app can create a running plan tailored to me. The flow should be quick, intuitive, and avoid any intimidating fitness jargon.  
* **Technical Tasks:**  
  * \[ \] Frontend: Create a multi-step UI for the onboarding flow (e.g., a carousel or a view pager).  
  * \[ \] Frontend: Design and implement the UI for the three multiple-choice questions.  
  * \[ \] Frontend: Store the user's selections locally on the device upon completion.  
  * \[ \] Logic: Define the data structure for the onboarding answers.  
  * \[ \] Design: Finalize the copy for questions and answer options.

### **Ticket: TFR-2 | Implement the Client-Side Plan Generation Engine**

* **Epic:** New User Onboarding & Plan Generation  
* **Goal:** To create a rules-based engine that can generate a multi-week, walk/run schedule based on the user's onboarding inputs.  
* **Description:** As a developer, I need to build a plan generation engine. This engine will take the user's goal, frequency, and experience level and output a structured workout plan. For the MVP, this logic will live on the client-side to minimize backend complexity.  
* **Technical Tasks:**  
  * \[ \] Logic: Design the algorithm that maps inputs (e.g., "Beginner," "3 days/week") to a specific workout schedule.  
  * \[ \] Logic: Define the data model for a "plan" (a collection of weeks) and a "workout" (containing warm-up, run, and cool-down phases).  
  * \[ \] Logic: Implement the function generatePlan(inputs) that returns the full workout plan object.  
  * \[ \] Frontend: After onboarding is complete, call the generatePlan function and save the resulting plan to the device's local storage.  
  * \[ \] QA: Create unit tests to verify that the engine produces expected plans for different input combinations.

### **Ticket: TFR-3 | Create the "One Thing" Home Screen**

* **Epic:** The Core Experience: Home Screen & Workout Guidance  
* **Goal:** To provide a simple, focused home screen that only shows the user's next scheduled workout, reducing cognitive load and intimidation.  
* **Description:** As a user, I want the home screen to only display a single card for my next scheduled workout so I know exactly what I need to do today without any distractions. The card should show key information like the workout type and duration.  
* **Technical Tasks:**  
  * \[ \] Frontend: Build the home screen UI component.  
  * \[ \] Frontend: Implement logic to read the user's saved plan from local storage.  
  * \[ \] Frontend: Implement logic to identify and display the *next* upcoming workout from the plan.  
  * \[ \] Frontend: Ensure the card is tappable, leading to the workout detail view (TFR-4).  
  * \[ \] Design: Finalize the design of the workout card (typography, layout, colors).

### **Ticket: TFR-4 | Build the Three-Tab Workout Detail View**

* **Epic:** The Core Experience: Home Screen & Workout Guidance  
* **Goal:** To present the workout in a clear, easy-to-digest format with distinct sections for Warm-Up, Run, and Cool-Down.  
* **Description:** As a user, when I tap on my workout for the day, I want to see a simple three-tab view. This allows me to focus on one phase of the workout at a time.  
* **Technical Tasks:**  
  * \[ \] Frontend: Create a new screen for workout details.  
  * \[ \] Frontend: Implement a tabbed navigation component with three tabs: "Warm-Up," "Run," and "Cool-Down."  
  * \[ \] Frontend: Populate the content of each tab based on the data for the selected workout object.  
  * \[ \] Frontend: Ensure navigation back to the home screen is clear.

### **Ticket: TFR-5 | Display Exercise Instructions with GIFs**

* **Epic:** The Core Experience: Home Screen & Workout Guidance  
* **Goal:** To provide clear, visual guidance for warm-up and cool-down exercises.  
* **Description:** As a user, I want to see simple text instructions and looping GIFs for each warm-up and cool-down exercise so I can perform them correctly without needing to watch a full video.  
* **Technical Tasks:**  
  * \[ \] Assets: Source or create lightweight, optimized GIFs for 5-6 core warm-up and cool-down stretches.  
  * \[ \] Assets: Bundle the GIF assets within the application package for offline access.  
  * \[ \] Frontend: Create a reusable UI component that displays an exercise title, text description, and a GIF.  
  * \[ \] Frontend: Integrate this component into the "Warm-Up" and "Cool-Down" tabs of the workout detail view (TFR-4).

### **Ticket: TFR-6 | Display Run Interval Structure**

* **Epic:** The Core Experience: Home Screen & Workout Guidance  
* **Goal:** To clearly communicate the structure of the walk/run portion of the workout.  
* **Description:** As a user, I want the "Run" tab to clearly state the interval structure (e.g., "Walk 2 min, Run 1 min, Repeat 4x"). This information should be front and center and easy to understand at a glance.  
* **Technical Tasks:**  
  * \[ \] Frontend: Design the layout for the "Run" tab content.  
  * \[ \] Frontend: Implement the logic to parse the run phase data from the workout object.  
  * \[ \] Frontend: Display the interval information in a large, readable format.

### **Ticket: TFR-7 | Integrate Wearable Sync (Apple Health & Garmin Connect)**

* **Epic:** Data Sync & The "Forgiving" Algorithm  
* **Goal:** To allow users to connect their existing wearable accounts to enable automatic run detection.  
* **Description:** As a user, I want to connect my Apple Health or Garmin Connect account so the app can automatically detect my completed runs. This should be a simple, one-time setup process from a settings menu.  
* **Technical Tasks:**  
  * \[ \] Backend/Infra: Register for developer accounts with Apple and Garmin.  
  * \[ \] iOS: Implement the HealthKit integration, including the permission request flow to read workout data.  
  * \[ \] Android/iOS: Implement the Garmin Connect API OAuth 2.0 flow for user authorization.  
  * \[ \] Frontend: Build the settings screen UI where users can initiate the connection to these services.  
  * \[ \] Frontend: Securely store the authentication tokens/keys on the device after a successful connection.

### **Ticket: TFR-8 | Implement Run Data Fetching Logic**

* **Epic:** Data Sync & The "Forgiving" Algorithm  
* **Goal:** To fetch recent run data from the user's connected wearable service.  
* **Description:** As a developer, I need to implement a process that fetches recent running workout data from the connected third-party service. This should trigger when the app is opened to ensure data is fresh.  
* **Technical Tasks:**  
  * \[ \] Logic: Create a function that, on app open, checks if a service (HealthKit/Garmin) is connected.  
  * \[ \] Logic (iOS): If HealthKit is connected, query for running workouts from the last 24-48 hours.  
  * \[ \] Logic (Garmin): If Garmin is connected, use the stored token to make an API call to fetch recent workouts.  
  * \[ \] Logic: Normalize the data received from both sources into a consistent internal format.  
  * \[ \] Logic: Store a timestamp of the last completed run locally to avoid duplicate processing.

### **Ticket: TFR-9 | Show Celebratory Message for Completed Run**

* **Epic:** Data Sync & The "Forgiving" Algorithm  
* **Goal:** To provide positive reinforcement to the user after they have successfully completed and synced a run.  
* **Description:** As a user, after I complete a run and the app syncs the data, I want to receive a simple, celebratory confirmation message in the app. This makes me feel accomplished and acknowledged.  
* **Technical Tasks:**  
  * \[ \] Logic: After the data fetching logic (TFR-8) identifies a new completed run that matches a scheduled workout, set a flag indicating completion.  
  * \[ \] Frontend: When the home screen loads, check for the completion flag.  
  * \[ \] Frontend: If the run is complete, display a celebratory modal or a temporary celebratory state on the home screen (e.g., "Great job on your run\!").  
  * \[ \] Design: Finalize the copy and design for the celebratory message.

### **Ticket: TFR-10 | Implement the "Forgiving" Rescheduling Algorithm**

* **Epic:** Data Sync & The "Forgiving" Algorithm  
* **Goal:** To implement the core value proposition: automatically and supportively rescheduling a missed workout.  
* **Description:** As a user, if I miss a scheduled run, I want the app to automatically push my entire plan back by one day and greet me with a supportive, non-judgmental message. This removes the feeling of failure and encourages me to get back on track.  
* **Technical Tasks:**  
  * \[ \] Logic: On app open, check if the workout scheduled for the *previous* day was completed.  
  * \[ \] Logic: If the previous day's workout was not completed and a workout is not scheduled for *today*, trigger the rescheduling logic.  
  * \[ \] Logic: Update the scheduled dates for all future, uncompleted workouts in the user's plan by shifting them one day forward.  
  * \[ \] Frontend: Display a specific, supportive message on the home screen when a reschedule occurs (e.g., "Life happens\! We've moved yesterday's run to today.").  
  * \[ \] QA: Test edge cases, such as missing multiple days in a row. For MVP, the logic should simply shift the plan forward from the first missed day.

### **Ticket: TFR-11 | Set Up 14-Day Free Trial**

* **Epic:** Monetization \- Trial & Subscription  
* **Goal:** To allow every new user to experience the full app for 14 days without payment.  
* **Description:** As a new user, I want to automatically start a 14-day free trial upon creating my account so I can experience the full value of the app before being asked to pay.  
* **Technical Tasks:**  
  * \[ \] Logic: When a user account is created (or on first app open), store a trialStartDate timestamp in local storage.  
  * \[ \] Logic: Implement a helper function isTrialActive() that returns true if the current date is within 14 days of the trialStartDate.

### **Ticket: TFR-12 | Implement Post-Trial Paywall**

* **Epic:** Monetization \- Trial & Subscription  
* **Goal:** To restrict access to the app after the trial period has ended, prompting the user to subscribe.  
* **Description:** As a developer, I need to implement a paywall that restricts access to the app after the 14-day trial period has expired. The paywall should clearly explain the value of subscribing.  
* **Technical Tasks:**  
  * \[ \] Logic: On app open, check if isTrialActive() is false and if the user is not subscribed.  
  * \[ \] Frontend: If the trial is over and there is no active subscription, display a full-screen modal paywall.  
  * \[ \] Frontend: The paywall modal should block access to the main app functionality (like the home screen).  
  * \[ \] Frontend: The paywall must present the subscription options (TFR-13).

### **Ticket: TFR-13 | Integrate In-App Purchases (Monthly/Annual)**

* **Epic:** Monetization \- Trial & Subscription  
* **Goal:** To allow users to purchase a subscription.  
* **Description:** As a trial user whose trial has expired, I want to be presented with options to subscribe to a monthly or annual plan so I can continue using the app.  
* **Technical Tasks:**  
  * \[ \] Backend/Infra: Set up in-app purchase products in App Store Connect and Google Play Console.  
  * \[ \] Infra: Integrate a subscription management service like RevenueCat to simplify cross-platform purchase logic.  
  * \[ \] Frontend: On the paywall screen, display the monthly and annual subscription options with pricing loaded from the store.  
  * \[ \] Frontend: Implement the purchase flow when a user taps a subscription option.  
  * \[ \] Logic: On successful purchase, store the user's subscription status locally to unlock the app.