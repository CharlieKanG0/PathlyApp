import SwiftUI

struct OnboardingView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .goal:
                GoalSelectionView(
                    selectedGoal: $viewModel.userGoal,
                    onNext: {
                        viewModel.goToNextStep()
                    }
                )
            case .frequency:
                FrequencySelectionView(
                    selectedFrequency: $viewModel.userFrequency,
                    onNext: {
                        viewModel.goToNextStep()
                    },
                    onBack: {
                        viewModel.goToPreviousStep()
                    }
                )
            case .experience:
                ExperienceSelectionView(
                    selectedExperience: $viewModel.userExperience,
                    onFinish: {
                        Task {
                            await viewModel.completeOnboarding(coordinator: coordinator)
                        }
                    },
                    onBack: {
                        viewModel.goToPreviousStep()
                    }
                )
            }
        }
        .animation(.default, value: viewModel.currentStep)
    }
}

#Preview {
    OnboardingView(coordinator: AppCoordinator(container: AppContainer()))
}