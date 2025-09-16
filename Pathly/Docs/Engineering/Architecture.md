# Architecture

> SwiftUI-first, MVVM with lightweight Coordinators, Use-Cases, and Repository pattern. Simple to start, easy to scale.

---

## 1) Goals & Principles

* **Keep it simple**: minimal ceremony, fast iteration.
* **Separation of concerns**: UI ≠ business logic ≠ IO.
* **Testable by default**: pure use-cases and protocol-backed repos.
* **Predictable state**: `ObservableObject` + `@StateObject` + `async/await`.
* **Module boundaries**: feature-first organization; core infra isolated.
* **Incremental scalability**: start light, introduce more structure only when needed.

---

## 2) High-Level Overview

```
+------------------+     +------------------+     +--------------------+
|   Presentation   | --> |      Domain      | --> |        Data        |
| SwiftUI + MVVM   |     | UseCases, Models |     | Repos (impl), IO   |
+------------------+     +------------------+     +--------------------+
           ^                       ^                        ^
           |                       |                        |
           |                       |                        |
           +-------------------- CoreKit -------------------+
                   (Networking, Persistence, Utilities,
                     DesignSystem, Analytics, Logging)
```

**Dependency rule**

* `App` depends on `Features` + `CoreKit` + `DomainKit`
* `Features/*` depend on `DomainKit` (+ `CoreKit` for UI bits)
* `DataKit` implements `DomainKit`’s repository protocols using `CoreKit` IO
* `DomainKit` is pure Swift (no UI frameworks)

---

## 3) Modules & Folders

```
MyApp/
├─ MyApp/                     // iOS app target (thin)
│  ├─ App.swift               // @main entry
│  ├─ AppConfig/              // build configs, env switching
│  ├─ DI/                     // AppContainer, DependencyGraph
│  ├─ Navigation/             // AppCoordinator, Route
│  └─ Resources/              // Assets, Localizable.strings
│
├─ Packages/
│  ├─ CoreKit/                // infra shared across app
│  │  ├─ Networking/          // HTTPClient, APIRequest, APIError
│  │  ├─ Persistence/         // SwiftDataStack or Core Data, Keychain, UserDefaults
│  │  ├─ DesignSystem/        // Colors, Typography, Components
│  │  ├─ Analytics/           // AnalyticsClient, events
│  │  └─ Utilities/           // Logger, date utils, ImageCacheActor, etc.
│  │
│  ├─ DomainKit/              // pure business logic & contracts
│  │  ├─ Entities/            // value types (User, Plan, Workout, etc.)
│  │  ├─ ValueObjects/        // GoalInput, Duration, Distance, Pace
│  │  ├─ UseCases/            // GeneratePlanUseCase, FetchWorkoutsUseCase...
│  │  └─ Repositories/        // protocols (PlanRepository, UserRepository...)
│  │
│  └─ DataKit/                // repo implementations (depends on CoreKit)
│     ├─ DTOs/                // API DTOs, mappers
│     ├─ Mappers/             // DTO <-> Domain converters
│     ├─ Sources/             // network, persistence data sources
│     └─ Repositories/        // *RepositoryImpl (conform to Domain protocols)
│
└─ Features/                  // feature-first (package later if needed)
   ├─ Onboarding/
   │  ├─ Views/               // OnboardingView, GoalPickerView
   │  ├─ ViewModels/          // OnboardingViewModel
   │  └─ Coordinator/         // OnboardingCoordinator
   ├─ Plan/
   │  ├─ Views/               // PlanView, PlanDetailView
   │  ├─ ViewModels/          // PlanViewModel
   │  └─ Coordinator/         // PlanCoordinator
   ├─ RunTracking/
   └─ Settings/
```

> **Tip:** Start with folders. When compile times or boundaries need enforcing, convert folders to **Swift Packages** (`CoreKit`, `DomainKit`, `DataKit`, `Feature.<Name>`).

---

## 4) Layer Responsibilities

### Presentation (SwiftUI + MVVM)

* **View**: pure render from state; emits user intents.
* **ViewModel (`ObservableObject`)**: owns screen state via `@Published`; calls **UseCases**; maps domain models to view state.
* **Coordinator**: constructs screens, wires dependencies, drives navigation (keeps navigation out of VMs).

### Domain

* **Entities**: value types representing core business data.
* **Value Objects**: small, validated types (e.g., `Pace`, `Distance`).
* **UseCases**: single-responsibility application services (pure when possible).
* **Repository Protocols**: IO-free contracts (implemented in Data layer).

### Data

* **Data Sources**: network, persistence.
* **Repository Implementations**: compose data sources; map **DTO ↔ Domain**.
* **Mappers**: deterministic conversions (keep out of VMs/use-cases).

### CoreKit

* **Networking**: `HTTPClient`, request building, decoding.
* **Persistence**: SwiftData/Core Data wrapper, Keychain, UserDefaults.
* **DesignSystem**: foundation styles + reusable SwiftUI components.
* **Utilities**: logging, concurrency helpers (actors), feature flags, etc.

---

## 5) State, Concurrency, and Navigation

### State management

* Local state: `@State` (inside View)
* Screen state: `@StateObject` ViewModel
* Shared screen child: `@ObservedObject` / `@Binding`
* Cross-feature data: inject via constructor/Coordinator, or `@EnvironmentObject` sparingly for app-wide singletons (e.g., `SessionStore`)

### Concurrency rules

* Use **`async/await`** end-to-end.
* Keep UI updates on **MainActor**:

  * Mark VMs `@MainActor` or methods that mutate `@Published` properties.
* Shared mutable infra (e.g., image cache) via **actors**:

  * `final actor ImageCacheActor { /* thread-safe */ }`

### Navigation

* **`NavigationStack`** + a **Coordinator** per flow:

  * Coordinator owns `NavigationPath` and pushes typed `Route`s.
  * VMs emit intents; Coordinator decides navigation.

---

## 6) Dependency Injection

* Prefer **constructor injection** on VMs and UseCases.
* Protocols in Domain; concrete implementations in Data/Core.
* A tiny **AppContainer** assembles the graph at startup.

```swift
// MyApp/DI/AppContainer.swift
import CoreKit, DomainKit, DataKit

struct AppContainer {
    // Core
    let http = HTTPClient(baseURL: URL(string: Env.apiBaseURL)!)
    let store = SwiftDataStack()
    let keychain = KeychainStore()
    let analytics = AnalyticsClient()

    // Repositories
    var planRepository: PlanRepository { PlanRepositoryImpl(http: http, store: store) }
    var userRepository: UserRepository { UserRepositoryImpl(http: http, keychain: keychain) }

    // UseCases
    var generatePlan: GeneratePlanUseCase { .init(repo: planRepository) }
    var fetchCurrentPlan: FetchCurrentPlanUseCase { .init(repo: planRepository) }
}
```

---

## 7) Networking

* `HTTPClient` wraps `URLSession` with:

  * Request builders (`APIRequest`), decoders, interceptors (auth token, retry).
  * Unified `APIError` (status, payload, underlying).
* Keep endpoints in repo impls or a `PlanAPI` namespace.
* Decode to **DTOs**, then map to **Domain**.

```swift
// CoreKit/Networking/APIRequest.swift
public struct APIRequest<Body: Encodable, Response: Decodable> {
    public let path: String
    public let method: HTTPMethod
    public var body: Body?
}
```

---

## 8) Persistence

* Start with **SwiftData** (or Core Data) wrapper for simplicity:

  * `SwiftDataStack` exposes async helpers (`fetch`, `save`, `delete`).
* Use **DTOs/entities** rather than persistence models in Domain.
* For simple settings/session, use **Keychain** and **UserDefaults**.

---

## 9) Errors & Reporting

* Normalize errors at each boundary:

  * Network → `APIError`
  * Repos → `DomainError` (e.g., `.unauthorized`, `.validation`, `.offline`)
* VMs map `DomainError` → user-facing messages.
* Log unexpected errors via `Logger` and **AnalyticsClient** (non-PII).

---

## 10) Feature Example (End-to-End)

**Domain**

```swift
// DomainKit/Repositories/PlanRepository.swift
public protocol PlanRepository {
    func generatePlan(goal: GoalInput) async throws -> Plan
    func fetchCurrentPlan() async throws -> Plan?
}
```

```swift
// DomainKit/UseCases/GeneratePlanUseCase.swift
public struct GeneratePlanUseCase {
    private let repo: PlanRepository
    public init(repo: PlanRepository) { self.repo = repo }
    public func execute(goal: GoalInput) async throws -> Plan {
        try await repo.generatePlan(goal: goal)
    }
}
```

**Data**

```swift
// DataKit/Repositories/PlanRepositoryImpl.swift
import DomainKit, CoreKit

public final class PlanRepositoryImpl: PlanRepository {
    private let http: HTTPClient
    private let store: SwiftDataStack

    public init(http: HTTPClient, store: SwiftDataStack) {
        self.http = http; this.store = store
    }

    public func generatePlan(goal: GoalInput) async throws -> Plan {
        let req = APIRequest(path: "/plans", method: .post, body: goal)
        let dto: PlanDTO = try await http.send(req)
        let plan = dto.toDomain()
        try await store.save(plan)
        return plan
    }

    public func fetchCurrentPlan() async throws -> Plan? {
        try await store.fetchCurrentPlan()
    }
}
```

**Presentation**

```swift
// Features/Plan/ViewModels/PlanViewModel.swift
@MainActor
final class PlanViewModel: ObservableObject {
    @Published var plan: Plan?
    @Published var isLoading = false
    @Published var error: String?

    private let generatePlan: GeneratePlanUseCase
    private let analytics: AnalyticsClient

    init(generatePlan: GeneratePlanUseCase, analytics: AnalyticsClient) {
        self.generatePlan = generatePlan
        self.analytics = analytics
    }

    func create(goal: GoalInput) async {
        isLoading = true; defer { isLoading = false }
        do {
            let result = try await generatePlan.execute(goal: goal)
            plan = result
            analytics.track("plan_created")
        } catch {
            self.error = Self.userMessage(from: error)
        }
    }

    private static func userMessage(from error: Error) -> String { "Something went wrong." }
}
```

```swift
// Features/Plan/Coordinator/PlanCoordinator.swift
@MainActor
final class PlanCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    private let container: AppContainer

    init(container: AppContainer) { self.container = container }

    func start() -> some View {
        PlanView(vm: PlanViewModel(
            generatePlan: container.generatePlan,
            analytics: container.analytics
        )).environmentObject(self)
    }

    func showPlanDetail(_ plan: Plan) {
        path.append(Route.planDetail(plan))
    }
}
```

---

## 11) Configuration & Environments

* Schemes: **Debug**, **Staging**, **Release**.
* Use `.xcconfig` files for:

  * `API_BASE_URL`, feature flags, logging level.
* Inject env values into `AppContainer` via `Env` helper.

---

## 12) Analytics & Logging

* `AnalyticsClient` abstracts providers (Firebase, Segment, etc.).
* Keep event names centralized (enum or constants).
* `Logger` thin wrapper around `os_log`/`print` with levels.

---

## 13) Security

* Secrets **never** in source; use build settings / CI variables.
* Store tokens in **Keychain**.
* Network: TLS only; pinning optional; handle refresh tokens centrally.

---

## 14) Accessibility & Localization

* Use semantic SwiftUI components; test with larger fonts and VoiceOver.
* `Localizable.strings` from day one; avoid hardcoding.

---

## 15) Performance

* Prefer value types; avoid retaining heavy objects in VMs.
* Image caching via **actor**.
* Use Instruments (Time Profiler, Allocations) on slow screens.

---

## 16) Testing Strategy

* **Unit tests** (fast):

  * UseCases: pure, no mocks beyond repos.
  * Repositories: mock `HTTPClient`/store; a few integration tests with real decoding.
  * ViewModels: input → state assertions (use `MainActor` test helpers).
* **UI tests** (selective): happy paths, critical regressions.
* **Snapshot tests** (optional): key screens.
* Run tests + SwiftFormat/SwiftLint in CI.

---

## 17) Coding Guidelines

* SwiftFormat + SwiftLint (commit hooks).
* Naming:

  * `XxxView`, `XxxViewModel`, `XxxCoordinator`, `XxxUseCase`, `XxxRepository`.
* One responsibility per type; files under 200–300 lines where possible.
* No business logic in Views; no IO in Domain.

---

## 18) Roadmap to Scale (optional)

* When features grow complex or team expands, consider:

  * Converting features to **Swift Packages**.
  * Introducing **The Composable Architecture** (TCA) **per complex feature only**, keeping the rest MVVM.
  * Adding a **DesignSystem** package with tokens and components.
  * Background tasks, push notifications modules.

---

## 19) “How to Add a New Feature” Checklist

1. **Domain**

   * Define Entities / ValueObjects (pure)
   * Add UseCases
   * Add Repository protocol (if new IO needed)

2. **Data**

   * Add DTOs + Mappers
   * Implement Repository protocol
   * Wire into `AppContainer`

3. **Presentation**

   * Create View, ViewModel, Coordinator
   * Inject UseCases via Coordinator

4. **Tests**

   * UseCase tests
   * Repo tests (mock HTTP/persistence)
   * VM state tests

---

## 20) Example: Minimal File Stubs

```swift
// DomainKit/ValueObjects/GoalInput.swift
public struct GoalInput: Codable, Equatable {
    public enum Kind: String, Codable { case faster, longer }
    public let kind: Kind
    public let baseRunMinutes: Int
}

// DomainKit/Entities/Plan.swift
public struct Plan: Codable, Equatable {
    public let id: UUID
    public let weeks: [Week]
    public struct Week: Codable, Equatable {
        public let number: Int
        public let sessions: [Session]
    }
    public struct Session: Codable, Equatable {
        public let day: Int
        public let durationMinutes: Int
        public let intensity: Int
    }
}
```

---

# Health/Running Data Placement (HealthKit & WorkoutKit)

In this architecture, **all HealthKit/WorkoutKit specifics live in the *Data* layer**, with clean contracts in *Domain*, and **features consume them via use-cases**.

## Placement

### Domain (pure, framework-agnostic)

Define the *contracts* and *models*—no `HealthKit` imports here.

* **Entities / Value Objects**

  * `RunWorkout`, `RunSample`, `HeartRateBPM`, `Pace`, `Distance`, `Calories`, `PermissionStatus`
* **Repository Protocols**

  * `HealthRepository` (read metrics, request permissions)
  * `WorkoutRepository` (start/stop live workouts, stream live metrics)
* **Use Cases**

  * `RequestHealthPermissionsUseCase`
  * `FetchRunWorkoutsUseCase`
  * `FetchDailyMetricsUseCase`
  * `StartRunSessionUseCase`, `EndRunSessionUseCase`
  * `ObserveLiveMetricsUseCase`
  * `SaveManualRunUseCase` (optional)

### Data (Apple frameworks, IO)

* `HealthRepositoryImpl` → wraps `HKHealthStore`, permissions, queries
* `WorkoutRepositoryImpl` → wraps `HKWorkoutSession` / WorkoutKit for live runs
* `HealthKitDataSource` → helpers (queries, unit conversions, background delivery)
* **Mapping**: convert `HKQuantitySample`/`HKWorkout` ⇄ Domain entities
* **Caching**: store anchors/snapshots via `UserDefaults` or SwiftData

### Features (UI)

* `RunTrackingViewModel` depends on **UseCases** only.
* `OnboardingViewModel` calls `RequestHealthPermissionsUseCase`.

---

## Folder sketch (relevant parts)

```
Packages/
  DomainKit/
    Entities/
      RunWorkout.swift
      RunSample.swift
      HeartRateBPM.swift
      Distance.swift
      Pace.swift
      PermissionStatus.swift
    Repositories/
      HealthRepository.swift
      WorkoutRepository.swift
    UseCases/
      RequestHealthPermissionsUseCase.swift
      FetchRunWorkoutsUseCase.swift
      FetchDailyMetricsUseCase.swift
      StartRunSessionUseCase.swift
      EndRunSessionUseCase.swift
      ObserveLiveMetricsUseCase.swift

  DataKit/
    HealthKit/
      HealthKitDataSource.swift         // HKHealthStore, queries, auth
      HealthRepositoryImpl.swift        // implements Domain.HealthRepository
      WorkoutRepositoryImpl.swift       // implements Domain.WorkoutRepository
      Mappers/
        HKWorkout+Mapping.swift
        HKQuantitySample+Mapping.swift
      Models/
        // DTOs if needed
    Persistence/
      HealthAnchorsStore.swift          // saves HKQuery anchors, optional

Features/
  RunTracking/
    Views/
      RunView.swift
      RunSummaryView.swift
    ViewModels/
      RunTrackingViewModel.swift
    Coordinator/
      RunTrackingCoordinator.swift
```

---

## Example contracts (Domain)

```swift
// DomainKit/Repositories/HealthRepository.swift
public protocol HealthRepository {
    func permissionStatus(for types: Set<HealthDataType>) async -> PermissionStatus
    func requestPermissions(for types: Set<HealthDataType>) async throws -> PermissionStatus

    func fetchWorkouts(from: Date, to: Date) async throws -> [RunWorkout]
    func fetchDailyDistance(by dayRange: DateInterval) async throws -> [DailyDistance]
    func fetchSamples<T: Metric>(
        _ metric: T, from: Date, to: Date, interval: DateComponents?
    ) async throws -> [MetricBucket<T>]
}

// DomainKit/Repositories/WorkoutRepository.swift
public protocol WorkoutRepository {
    func startRun(configuration: RunConfig) async throws
    func endRun() async throws -> RunWorkout
    func liveMetrics() -> AsyncStream<LiveMetrics>  // HR, pace, distance, cadence
}
```

Supporting types:

```swift
public enum PermissionStatus { case notDetermined, denied, limited, authorized }

public struct RunWorkout: Equatable {
    public let id: UUID
    public let start: Date
    public let end: Date
    public let distanceMeters: Double
    public let duration: TimeInterval
    public let avgHeartRateBPM: Double?
    public let avgPaceSecPerKm: Double?
}

public struct LiveMetrics: Equatable {
    public let timestamp: Date
    public let heartRateBPM: Double?
    public let currentPaceSecPerKm: Double?
    public let distanceMeters: Double
    public let cadenceSPM: Double?
}
```

Use-cases wire straight through:

```swift
public struct StartRunSessionUseCase {
    private let repo: WorkoutRepository
    public init(repo: WorkoutRepository) { self.repo = repo }
    public func execute(config: RunConfig) async throws { try await repo.startRun(configuration: config) }
}

public struct ObserveLiveMetricsUseCase {
    private let repo: WorkoutRepository
    public init(repo: WorkoutRepository) { self.repo = repo }
    public func stream() -> AsyncStream<LiveMetrics> { repo.liveMetrics() }
}
```

---

## DI wiring (excerpt)

```swift
struct AppContainer {
    // Core
    let hkStore = HKHealthStore()
    let anchors = HealthAnchorsStore(userDefaults: .standard)

    // Data
    var healthRepository: HealthRepository {
        HealthRepositoryImpl(healthStore: hkStore, anchors: anchors)
    }
    var workoutRepository: WorkoutRepository {
        WorkoutRepositoryImpl(healthStore: hkStore)
    }

    // UseCases
    var requestHealthPermissions: RequestHealthPermissionsUseCase {
        .init(repo: healthRepository)
    }
    var startRun: StartRunSessionUseCase { .init(repo: workoutRepository) }
    var endRun: EndRunSessionUseCase { .init(repo: workoutRepository) }
    var observeLive: ObserveLiveMetricsUseCase { .init(repo: workoutRepository) }
}
```

---

## Testing notes

* **Domain**: trivial to unit test (pure structs/functions).
* **Data**: wrap HealthKit calls; in tests, provide a `FakeHealthStore` or protocol-gate the specific HK queries and inject fakes.
* **VMs**: feed fake repositories that return controlled streams for live metrics and assert state transitions.

---

## TL;DR

* **Domain**: define *what* you need (entities + repo protocols + use-cases).
* **Data**: implement *how* with HealthKit/WorkoutKit, mapping to Domain.
* **Features**: depend only on use-cases—no HealthKit in UI.
* Optional watch app can reuse Domain/Data; use a dedicated `WorkoutRepositoryImpl` tailored for watch sessions.
