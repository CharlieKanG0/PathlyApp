import Foundation

@MainActor
class WorkoutDetailViewModel: ObservableObject {
    @Published var workout: Workout

    init(workout: Workout) {
        self.workout = workout
    }

    var warmUpExercises: [Exercise] {
        workout.warmUp
    }

    var runIntervals: [Interval] {
        workout.run.intervals
    }

    var coolDownExercises: [Exercise] {
        workout.coolDown
    }

    /// Creates a human-readable summary of the run segment.
    var runIntervalSummary: String {
        guard let firstRun = runIntervals.first(where: { $0.type == .run }),
              let firstWalk = runIntervals.first(where: { $0.type == .walk }) else {
            return "Run Segment"
        }
        
        let runCount = runIntervals.filter { $0.type == .run }.count
        
        let runDuration = Int(firstRun.duration / 60)
        let walkDuration = Int(firstWalk.duration / 60)
        
        var summary = ""
        if walkDuration > 0 {
            summary += "Walk \(walkDuration) min, "
        }
        if runDuration > 0 {
            summary += "Run \(runDuration) min"
        }
        
        if runCount > 1 {
            summary += ", Repeat \(runCount)x"
        }
        
        return summary
    }
}