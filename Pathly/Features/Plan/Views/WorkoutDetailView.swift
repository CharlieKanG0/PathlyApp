import SwiftUI

fileprivate enum WorkoutTab {
    case warmUp, run, coolDown
}

struct WorkoutDetailView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var viewModel: WorkoutDetailViewModel
    @State private var selectedTab: WorkoutTab = .run // Default to the "Run" tab

    init(coordinator: AppCoordinator, workout: Workout) {
        self.coordinator = coordinator
        _viewModel = StateObject(wrappedValue: WorkoutDetailViewModel(workout: workout))
    }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                WarmUpView(exercises: viewModel.warmUpExercises)
                    .tabItem {
                        Label("Warm-Up", systemImage: "figure.walk")
                    }
                    .tag(WorkoutTab.warmUp)
                
                RunView(intervals: viewModel.runIntervals, summary: viewModel.runIntervalSummary)
                    .tabItem {
                        Label("Run", systemImage: "figure.run")
                    }
                    .tag(WorkoutTab.run)
                
                CoolDownView(exercises: viewModel.coolDownExercises)
                    .tabItem {
                        Label("Cool-Down", systemImage: "figure.walk.motion")
                    }
                    .tag(WorkoutTab.coolDown)
            }
        }
        .navigationTitle("Today's Workout")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WarmUpView: View {
    let exercises: [Exercise]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(exercises, id: \.self) { exercise in
                    ExerciseCard(
                        title: exercise.name,
                        description: exercise.description,
                        duration: "\(Int(exercise.duration / 60)) min"
                    )
                }
            }
            .padding()
        }
    }
}

struct RunView: View {
    let intervals: [Interval]
    let summary: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text(summary)
                    .font(.title2)
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 10) {
                    ForEach(0..<intervals.count, id: \.self) { index in
                        let interval = intervals[index]
                        IntervalRow(
                            type: interval.type.rawValue.capitalized,
                            duration: "\(Int(interval.duration / 60)) min",
                            color: interval.type == .run ? .red : .blue
                        )
                    }
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
                .cornerRadius(10)
                
                let totalTime = intervals.reduce(0) { $0 + $1.duration }
                Text("Total time: \(Int(totalTime / 60)) min")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

struct CoolDownView: View {
    let exercises: [Exercise]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(exercises, id: \.self) { exercise in
                    ExerciseCard(
                        title: exercise.name,
                        description: exercise.description,
                        duration: "\(Int(exercise.duration / 60)) min"
                    )
                }
            }
            .padding()
        }
    }
}

struct ExerciseCard: View {
    let title: String
    let description: String
    let duration: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(duration)
                    .font(.subheadline)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Text(description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Placeholder for GIF
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(UIColor.secondarySystemGroupedBackground))
                .frame(height: 150)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("Exercise GIF")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                )
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct IntervalRow: View {
    let type: String
    let duration: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(type)
                .font(.headline)
                .foregroundColor(color)
            
            Spacer()
            
            Text(duration)
                .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let mockWorkout = Workout(
        date: Date(),
        warmUp: [Exercise(name: "Test Warm Up", description: "Desc...", duration: 60)],
        run: RunSegment(intervals: [Interval(duration: 120, type: .walk), Interval(duration: 60, type: .run)]),
        coolDown: [Exercise(name: "Test Cool Down", description: "Desc...", duration: 60)]
    )
    return NavigationView {
        WorkoutDetailView(
            coordinator: AppCoordinator(container: AppContainer()),
            workout: mockWorkout
        )
    }
}