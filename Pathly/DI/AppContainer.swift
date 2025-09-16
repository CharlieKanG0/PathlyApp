import Foundation
import SwiftUI

/// Simple dependency container for the app. Expand with services as needed.
final class AppContainer: ObservableObject {
    // Core services
    private let userDefaults = UserDefaults.standard
    
    // App-wide configuration
    @Published var isFirstLaunch: Bool {
        didSet {
            userDefaults.set(isFirstLaunch, forKey: "isFirstLaunch")
        }
    }
    
    // Repositories
    lazy var planRepository: PlanRepository = {
        return PlanRepositoryImpl()
    }()
    
    // UseCases
    lazy var generatePlan: GeneratePlanUseCase = {
        return GeneratePlanUseCase(repo: planRepository)
    }()

    init() {
        // Load isFirstLaunch from UserDefaults or default to true
        self.isFirstLaunch = userDefaults.object(forKey: "isFirstLaunch") as? Bool ?? true
    }
}