import Foundation
import SwiftUI

// Define the app routes
enum Route: Hashable {
    case onboarding
    case home
    case workoutDetail
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
        NavigationStack(path: Binding(
            get: { self.path },
            set: { self.path = $0 }
        )) {
            // Decide initial screen. If onboarding needed, show onboarding.
            if container.isFirstLaunch {
                resolveView(for: .onboarding)
            } else {
                resolveView(for: .home)
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
        case .workoutDetail:
            WorkoutDetailView(coordinator: self)
        case .settings:
            SettingsView(coordinator: self)
        }
    }
    
    // Navigation methods
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateToHome() {
        path = NavigationPath()
        path.append(Route.home)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
}
