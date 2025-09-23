import Foundation
import SwiftUI

// Define the app routes
enum Route: Hashable {
    case onboarding
    case home
    case workoutDetail(Workout)
    case settings
}

final class AppCoordinator: ObservableObject {
    let container: AppContainer
    @Published var path = NavigationPath()
    
    init(container: AppContainer) {
        self.container = container
    }
    
    @ViewBuilder
    func startView() -> some View {
        // FIX 1: Use a custom Binding to resolve the @Published property compile error.
        NavigationStack(path: Binding(
            get: { self.path },
            set: { self.path = $0 }
        )) {
            // Determine the root view of the stack.
            let rootView = Group {
                if container.isFirstLaunch {
                    resolveView(for: .onboarding)
                } else {
                    resolveView(for: .home)
                }
            }
            
            // FIX 2: Apply the navigationDestination modifier to the root view
            // to handle all subsequent navigation pushes.
            rootView
                .navigationDestination(for: Route.self) { route in
                    self.resolveView(for: route)
                }
        }
    }
    
    @ViewBuilder
    func resolveView(for route: Route) -> some View {
        switch route {
        case .onboarding:
            OnboardingView(coordinator: self)
        case .home:
            HomeView(coordinator: self)
        case .workoutDetail(let workout):
            WorkoutDetailView(coordinator: self, workout: workout)
        case .settings:
            SettingsView(coordinator: self)
        }
    }
    
    // Navigation methods
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateToHome() {
        // To return to the root view (Home), we clear the navigation path.
        path = NavigationPath()
    }
    
    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}