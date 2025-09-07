

# Architecture

SwiftUI-first app using **MVVM + lightweight Coordinators + Use-Cases + Repository**.
Phase 0 keeps everything inside the Xcode app target using folders only (no SPM).
When the codebase grows, we can lift folders into local Swift Packages (Phase 1).

---

## Goals & Principles

* **Keep it simple** – minimal ceremony, fast iteration.
* **Separation of concerns** – UI ≠ domain logic ≠ IO.
* **Testable by default** – small use-cases, protocol-backed repositories.
* **Predictable state** – SwiftUI with `ObservableObject` and `async/await`.
* **Scale incrementally** – start with folders; extract to packages later.

---

## Layer Overview

```
Presentation (SwiftUI Views, ViewModels, Coordinators)
        ↓    (calls)
Domain (UseCases, Entities/ValueObjects, Repository *protocols*)
        ↓    (implemented by)
Data (Repository implementations, DTOs, Mappers, IO: Network/Persistence/HealthKit)

Core (shared infra: HTTP client, Keychain, SwiftData wrapper, utilities, design system)
```

**Rules**

* Views talk to **ViewModels** only.
* ViewModels use **UseCases** (Domain).
* UseCases depend on **Repository protocols** (Domain).
* **Data** implements those protocols and performs IO.
* **Core** hosts reusable infrastructure used by Data and (sometimes) Presentation.

---

## Folder Structure (Phase 0)

```
Pathly/
├─ App.swift (PathlyApp.swift)
├─ AppConfig/                # build config, Env helper, feature flags
├─ DI/                       # dependency wiring (AppContainer)
├─ Navigation/               # AppCoordinator, Route definitions
├─ Core/                     # "CoreKit-for-now"
│  ├─ Networking/            # HTTPClient, APIRequest, APIError
│  ├─ Persistence/           # SwiftData/CoreData wrapper, Keychain, UserDefaults
│  ├─ DesignSystem/          # theme, reusable SwiftUI components
│  └─ Utilities/             # Logger, date/currency utils, actors (e.g., ImageCacheActor)
├─ Domain/                   # "DomainKit-for-now"
│  ├─ Entities/              # e.g., User, Plan, Workout
│  ├─ ValueObjects/          # e.g., Pace, Distance, GoalInput
│  ├─ UseCases/              # e.g., GeneratePlanUseCase
│  └─ Repositories/          # protocols: PlanRepository, UserRepository, HealthRepository
├─ Data/                     # "DataKit-for-now"
│  ├─ DTOs/                  # API/DB models
│  ├─ Mappers/               # DTO <-> Domain mapping
│  ├─ Sources/               # Network/Persistence/HealthKit data sources
│  └─ Repositories/          # *RepositoryImpl classes conforming to Domain protocols
└─ Features/
   ├─ Onboarding/
   │  ├─ Views/              # OnboardingView, GoalPickerView
   │  └─ ViewModels/         # OnboardingViewModel
   ├─ Plan/
   │  ├─ Views/              # PlanView, PlanDetailView
   │  └─ ViewModels/         # PlanViewModel
   └─ Settings/
```

> **Note:** We keep *Coordinators* alongside navigation at the app level (and add per-feature coordinators as needed).

---

## Key Components

### Presentation

* **Views**: pure, declarative rendering from state. No business logic.
* **ViewModels** (`@MainActor`, `ObservableObject`):

  * Expose `@Published` state.
  * Call **UseCases** (async).
  * Map domain errors to user-facing messages.
* **Coordinators**:

  * Own `NavigationStack/Path` and typed `Route`s.
  * Build Views & ViewModels (dependency injection).
  * Keep navigation logic out of ViewModels.

### Domain (pure Swift; no imports from Apple UI/IO frameworks)

* **Entities/ValueObjects**: value types with invariants (e.g., `Pace`, `Distance`).
* **UseCases**: small orchestration units (single responsibility).
* **Repository Protocols**: IO contracts (implemented in Data).

### Data

* **Repositories**: concrete classes conforming to Domain protocols.
* **Sources**: `URLSession` networking, SwiftData/Core Data, **HealthKit/WorkoutKit**.
* **Mappers/DTOs**: deterministic conversion between IO and Domain types.

### Core

* **Networking** (`HTTPClient`, `APIRequest`, `APIError`).
* **Persistence** (SwiftData/Core Data helpers, Keychain, UserDefaults).
* **DesignSystem** (reusable SwiftUI components/tokens).
* **Utilities** (logging, analytics client, concurrency helpers/actors).

---

## Dependency Injection

We use a tiny app container to wire dependencies.

```swift
// DI/AppContainer.swift
import Foundation

struct AppContainer {
  // Core
  let http = HTTPClient(baseURL: URL(string: Env.apiBaseURL)!)
  let store = SwiftDataStack()
  let analytics = AnalyticsClient()

  // Repositories (Data)
  var planRepository: PlanRepository { PlanRepositoryImpl(http: http, store: store) }

  // UseCases (Domain)
  var generatePlan: GeneratePlanUseCase { .init(repo: planRepository) }
}
```

`PathlyApp` creates `AppContainer` and passes it to `AppCoordinator`, which constructs the start view.

---

## State & Concurrency

* Use `async/await` from ViewModels to UseCases/Repos.
* Mark ViewModels `@MainActor` (or only the mutating methods) to update `@Published` safely.
* Use **actors** for shared mutable infrastructure (e.g., image cache, metrics cache).

---

## Navigation

* **`NavigationStack`** with a top-level **AppCoordinator** and (optional) per-feature coordinators.
* Coordinators manage `NavigationPath` and push typed `Route` enums.

---

## Errors & Logging

* Normalize at boundaries:

  * Network → `APIError` (status, payload, underlying).
  * Repositories → `DomainError` (e.g., `.unauthorized`, `.offline`).
* ViewModels turn domain errors into user messages.
* Log unexpected errors via `Logger` and send safe analytics events.

---

## Health/Running Data (HealthKit & WorkoutKit)

* **Domain**: define contracts and models only.

  * `HealthRepository`, `WorkoutRepository`
  * Entities: `RunWorkout`, `LiveMetrics`, etc.
  * UseCases: request permissions, fetch workouts, start/end run, observe live metrics.
* **Data**: implement repositories using HealthKit/WorkoutKit.

  * `Data/Repositories/HealthRepositoryImpl.swift`
  * `Data/Repositories/WorkoutRepositoryImpl.swift`
  * Mapping from `HK*` types ↔ Domain entities.
* **Presentation**: depends on UseCases only; **no HealthKit imports** in UI.

---

## Testing

* **Unit** (PathlyTests):

  * UseCases: pure; mock repositories.
  * ViewModels: assert state transitions (loading → data/error) with fake UseCases.
  * Repositories: mock `HTTPClient`/store; a couple of integration tests for decoding.
* **UI** (PathlyUITests):

  * Smoke tests for critical flows.

---

## Coding Guidelines

* SwiftFormat & SwiftLint in the repo.
* Naming: `XxxView`, `XxxViewModel`, `XxxCoordinator`, `XxxUseCase`, `XxxRepository`.
* Views are dumb; ViewModels orchestrate; UseCases are small; Repos isolate IO.
* Keep files focused (≈200–300 lines).

---

## How to Add a Feature

1. **Domain**

   * Add Entities/ValueObjects if needed.
   * Add UseCases.
   * Add/extend Repository *protocols* if new IO is required.
2. **Data**

   * Add DTOs & Mappers.
   * Implement/extend Repository impls.
3. **Presentation**

   * Create `Features/<Feature>/Views` & `ViewModels`.
   * Wire the screen in the appropriate Coordinator.
4. **Tests**

   * Unit tests for UseCases & ViewModels.
   * Integration tests for Repos as needed.

---

## Phase 1 (When We Grow): Local Swift Packages

When compile times rise or you want enforced boundaries, move these folders into **local SPM packages**:

* `Core` → **CoreKit**
* `Domain` → **DomainKit**
* `Data` → **DataKit**

Enforce dependencies:

```
DataKit  →  DomainKit, CoreKit
DomainKit →  (no app frameworks)
App/Features → DomainKit (+ CoreKit for UI components)
```

Each package gets its own `Tests` target (fast feedback) and exposes only a small `public` API.

---

## Glossary

* **MVVM** – Model-View-ViewModel; our ViewModels mediate Views ↔ UseCases.
* **UseCase** – Small application service (one job), testable in isolation.
* **Repository** – Abstraction for data access; protocol in Domain, impl in Data.
* **Coordinator** – Object that builds screens and drives navigation.

---

**TL;DR:**
Folders now reflect clean boundaries (Presentation / Domain / Data / Core).
UI -> UseCases -> Repos (protocols) -> Repos (impl) -> IO.
When scale demands it, we’ll extract these folders into local Swift Packages to enforce the same structure at the compiler level.
