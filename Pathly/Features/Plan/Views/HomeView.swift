import SwiftUI

struct HomeView: View {
    @ObservedObject var coordinator: AppCoordinator
    @State private var nextWorkout: Workout?
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var currentUser: User?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text("Today's Run")
                    .font(.largeTitle)
                    .bold()
                
                if let errorMessage = errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.title)
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else if isLoading {
                    ProgressView("Loading your plan...")
                        .padding()
                } else if let workout = nextWorkout {
                    // Next workout card
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            Text("Next Workout")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("Today")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        
                        Text("Run/Walk Intervals")
                            .font(.title2)
                            .bold()
                        
                        Text(getWorkoutDuration(workout: workout) + " • " + getExperienceLevel())
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "figure.run")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                    .onTapGesture {
                        coordinator.navigate(to: .workoutDetail)
                    }
                } else {
                    // No workout found
                    VStack(spacing: 20) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No Workout Scheduled")
                            .font(.title2)
                            .bold()
                        
                        Text("Complete your onboarding to generate your personalized plan.")
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Complete Onboarding") {
                            coordinator.container.isFirstLaunch = true
                            coordinator.popToRoot()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }
                
                Spacer()
                
                // Progress section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Your Progress")
                        .font(.headline)
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("0")
                                .font(.title)
                                .bold()
                            Text("Runs Completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("0")
                                .font(.title)
                                .bold()
                            Text("Total Days")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
            .navigationTitle("Pathly")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        coordinator.navigate(to: .settings)
                    }) {
                        Image(systemName: "gear")
                    }
                }
            }
            .task {
                await loadUserData()
            }
        }
    }
    
    private func loadUserData() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // Try to get the current user
            let user = try await coordinator.container.userRepository.getCurrentUser()
            DispatchQueue.main.async {
                self.currentUser = user
            }
            
            guard let user = user else {
                DispatchQueue.main.async {
                    self.errorMessage = "Please complete onboarding to generate your plan."
                    self.isLoading = false
                }
                return
            }
            
            // Try to get the current plan
            guard let plan = try await coordinator.container.planRepository.getPlan(for: user.id) else {
                DispatchQueue.main.async {
                    self.errorMessage = "No plan found. Please complete onboarding."
                    self.isLoading = false
                }
                return
            }
            
            // Find the next workout (in a real app, you'd find the workout for today)
            // For now, we'll just take the first workout from the first week
            let nextWorkout = plan.weeks.first?.workouts.first
            
            DispatchQueue.main.async {
                self.nextWorkout = nextWorkout
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to load your plan: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
    
    private func getWorkoutDuration(workout: Workout) -> String {
        let totalSeconds = workout.warmUp.reduce(0) { result, exercise in
                              result + Int(exercise.duration)
                          } +
                          workout.run.intervals.reduce(0) { result, interval in
                              result + Int(interval.duration)
                          } +
                          workout.coolDown.reduce(0) { result, exercise in
                              result + Int(exercise.duration)
                          }
        
        let minutes = totalSeconds / 60
        return "\(minutes) min"
    }
    
    private func getExperienceLevel() -> String {
        return currentUser?.experience.displayName ?? "Beginner"
    }
}

#Preview {
    HomeView(coordinator: AppCoordinator(container: AppContainer()))
}