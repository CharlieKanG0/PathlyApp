import Foundation
import SwiftUI

final class AppCoordinator: ObservableObject {
    private let container: AppContainer

    init(container: AppContainer) {
        self.container = container
    }

    @ViewBuilder
    func startView() -> some View {
        // Decide initial screen. If onboarding needed, show onboarding.
        if container.isFirstLaunch {
            OnboardingView()
        } else {
            // Placeholder for HomeView or main tab view
            OnboardingView()
        }
    }
}
