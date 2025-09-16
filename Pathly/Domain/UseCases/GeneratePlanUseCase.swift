import Foundation

struct GeneratePlanUseCase {
    private let repository: PlanRepository
    
    init(repo: PlanRepository) {
        self.repository = repo
    }
    
    func execute(for user: User) async throws -> Plan {
        // For now, we'll create a simple plan
        // In a real implementation, this would be more complex based on user inputs
        let plan = createSamplePlan(for: user)
        try await repository.savePlan(plan)
        return plan
    }
    
    private func createSamplePlan(for user: User) -> Plan {
        // Create a simple 4-week plan
        let weeks = (1...4).map { weekNumber in
            Week(weekNumber: weekNumber, workouts: createSampleWorkouts(for: weekNumber, frequency: user.frequency))
        }
        
        return Plan(userId: user.id, weeks: weeks)
    }
    
    private func createSampleWorkouts(for week: Int, frequency: Frequency) -> [Workout] {
        let calendar = Calendar.current
        let today = Date()
        
        return (1...frequency.daysPerWeek).map { day in
            let workoutDate = calendar.date(byAdding: .day, value: (week - 1) * 7 + day, to: today)!
            
            // Create sample warm-up exercises
            let warmUp = [
                Exercise(name: "Leg Swings", description: "Stand upright and swing one leg forward and backward, then side to side. Repeat with the other leg.", duration: 60, gifName: "leg_swings"),
                Exercise(name: "Arm Circles", description: "Extend your arms out to the sides and make small circles, gradually increasing the size.", duration: 60, gifName: "arm_circles")
            ]
            
            // Create sample run segment
            let runIntervals = [
                Interval(duration: 120, type: .walk), // 2 minutes walk
                Interval(duration: 60, type: .run),   // 1 minute run
                Interval(duration: 120, type: .walk), // 2 minutes walk
                Interval(duration: 60, type: .run),   // 1 minute run
                Interval(duration: 120, type: .walk), // 2 minutes walk
                Interval(duration: 60, type: .run),   // 1 minute run
            ]
            let runSegment = RunSegment(intervals: runIntervals)
            
            // Create sample cool-down exercises
            let coolDown = [
                Exercise(name: "Hamstring Stretch", description: "Sit on the ground with one leg extended and reach toward your toes. Hold for 30 seconds and switch legs.", duration: 60, gifName: "hamstring_stretch"),
                Exercise(name: "Calf Stretch", description: "Stand facing a wall and place one foot behind you, pressing the heel down. Hold for 30 seconds and switch legs.", duration: 60, gifName: "calf_stretch")
            ]
            
            return Workout(date: workoutDate, warmUp: warmUp, run: runSegment, coolDown: coolDown)
        }
    }
}