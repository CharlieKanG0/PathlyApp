import Foundation

enum OnboardingStep: Int, CaseIterable {
    case goal = 0
    case frequency = 1
    case experience = 2
}

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .goal
    @Published var userGoal: Goal = .buildEndurance
    @Published var userFrequency: Frequency = .threeDays
    @Published var userExperience: Experience = .beginner
    
    func goToNextStep() {
        let nextStep = currentStep.rawValue + 1
        if nextStep < OnboardingStep.allCases.count {
            currentStep = OnboardingStep(rawValue: nextStep) ?? currentStep
        }
    }
    
    func goToPreviousStep() {
        let previousStep = currentStep.rawValue - 1
        if previousStep >= 0 {
            currentStep = OnboardingStep(rawValue: previousStep) ?? currentStep
        }
    }
    
    func completeOnboarding(coordinator: AppCoordinator) async {
        // Create user from selections
        let user = User(
            goal: userGoal,
            frequency: userFrequency,
            experience: userExperience
        )
        
        // Save user to persistence (to be implemented)
        // For now, we'll just print to console
        print("User created: \(user)")
        
        // Generate plan using the use case
        do {
            let plan = try await coordinator.container.generatePlan.execute(for: user)
            print("Plan generated: \(plan)")
        } catch {
            print("Error generating plan: \(error)")
        }
        
        // Mark onboarding as complete
        coordinator.container.isFirstLaunch = false
        coordinator.navigateToHome()
    }
}