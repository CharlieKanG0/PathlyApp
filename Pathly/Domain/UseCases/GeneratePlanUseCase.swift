import Foundation

struct GeneratePlanUseCase {
    private let repository: PlanRepository
    
    init(repo: PlanRepository) {
        self.repository = repo
    }
    
    func execute(for user: User) async throws -> Plan {
        let plan = createPersonalizedPlan(for: user)
        try await repository.savePlan(plan)
        return plan
    }
    
    private func createPersonalizedPlan(for user: User) -> Plan {
        // Create a 4-week plan
        let weeks = (1...4).map { weekNumber in
            Week(weekNumber: weekNumber, workouts: createWorkouts(for: weekNumber, user: user))
        }
        
        return Plan(userId: user.id, weeks: weeks)
    }
    
    private func createWorkouts(for week: Int, user: User) -> [Workout] {
        let calendar = Calendar.current
        let today = Date()
        
        // Create workouts based on user's frequency
        return (1...user.frequency.daysPerWeek).map { day in
            let workoutDate = calendar.date(byAdding: .day, value: (week - 1) * 7 + day, to: today)!
            
            // Create warm-up exercises based on experience level
            let warmUp = createWarmUpExercises(for: user.experience)
            
            // Create run segment based on goal, experience, and week
            let runSegment = createRunSegment(for: user, week: week)
            
            // Create cool-down exercises based on experience level
            let coolDown = createCoolDownExercises(for: user.experience)
            
            return Workout(date: workoutDate, warmUp: warmUp, run: runSegment, coolDown: coolDown)
        }
    }
    
    private func createWarmUpExercises(for experience: Experience) -> [Exercise] {
        switch experience {
        case .beginner:
            return [
                Exercise(name: "Leg Swings", description: "Stand upright and swing one leg forward and backward, then side to side. Repeat with the other leg.", duration: 60, gifName: "leg_swings"),
                Exercise(name: "Arm Circles", description: "Extend your arms out to the sides and make small circles, gradually increasing the size.", duration: 60, gifName: "arm_circles"),
                Exercise(name: "Marching in Place", description: "March in place for 30 seconds to get your blood flowing.", duration: 30, gifName: "marching")
            ]
        case .intermediate:
            return [
                Exercise(name: "Dynamic Leg Swings", description: "Swing each leg forward and backward 10 times, then side to side 10 times.", duration: 90, gifName: "dynamic_leg_swings"),
                Exercise(name: "Arm Swings", description: "Swing arms in large circles - 10 forward, 10 backward.", duration: 60, gifName: "arm_swings"),
                Exercise(name: "High Knees", description: "March in place bringing knees up to waist height for 30 seconds.", duration: 30, gifName: "high_knees")
            ]
        case .advanced:
            return [
                Exercise(name: "Dynamic Warm-Up", description: "Perform leg swings, arm circles, and torso twists for 2 minutes.", duration: 120, gifName: "dynamic_warmup"),
                Exercise(name: "Butt Kicks", description: "Jog in place kicking heels toward glutes for 30 seconds.", duration: 30, gifName: "butt_kicks"),
                Exercise(name: "Lunges", description: "Perform 10 walking lunges forward, then 10 walking lunges backward.", duration: 90, gifName: "lunges")
            ]
        }
    }
    
    private func createRunSegment(for user: User, week: Int) -> RunSegment {
        // Calculate progression based on week and experience
        let baseWalkTime = getBaseWalkTime(for: user.experience)
        let baseRunTime = getBaseRunTime(for: user.experience, week: week)
        let repeatCount = getRepeatCount(for: user.goal, week: week)
        
        var intervals: [Interval] = []
        
        // Create intervals based on walk/run pattern
        for _ in 1...repeatCount {
            intervals.append(Interval(duration: baseWalkTime, type: .walk))
            intervals.append(Interval(duration: baseRunTime, type: .run))
        }
        
        // Add final cool-down walk
        intervals.append(Interval(duration: baseWalkTime, type: .walk))
        
        return RunSegment(intervals: intervals)
    }
    
    private func getBaseWalkTime(for experience: Experience) -> TimeInterval {
        switch experience {
        case .beginner:
            return 120 // 2 minutes
        case .intermediate:
            return 90  // 1.5 minutes
        case .advanced:
            return 60  // 1 minute
        }
    }
    
    private func getBaseRunTime(for experience: Experience, week: Int) -> TimeInterval {
        let baseTime: TimeInterval
        
        switch experience {
        case .beginner:
            baseTime = 60 // 1 minute
        case .intermediate:
            baseTime = 120 // 2 minutes
        case .advanced:
            baseTime = 180 // 3 minutes
        }
        
        // Progressively increase run time each week
        let weekMultiplier = Double(week) * 0.2
        return baseTime * (1 + weekMultiplier)
    }
    
    private func getRepeatCount(for goal: Goal, week: Int) -> Int {
        let baseCount: Int
        
        switch goal {
        case .buildEndurance, .run5K:
            baseCount = 4
        case .run10K:
            baseCount = 5
        case .halfMarathon:
            baseCount = 6
        case .loseWeight:
            baseCount = 4
        case .marathon:
            baseCount = 7
        }
        
        // Adjust based on week (progressive increase)
        return min(baseCount + week - 1, baseCount + 3)
    }
    
    private func createCoolDownExercises(for experience: Experience) -> [Exercise] {
        switch experience {
        case .beginner:
            return [
                Exercise(name: "Hamstring Stretch", description: "Sit on the ground with one leg extended and reach toward your toes. Hold for 30 seconds and switch legs.", duration: 60, gifName: "hamstring_stretch"),
                Exercise(name: "Calf Stretch", description: "Stand facing a wall and place one foot behind you, pressing the heel down. Hold for 30 seconds and switch legs.", duration: 60, gifName: "calf_stretch"),
                Exercise(name: "Shoulder Stretch", description: "Bring one arm across your chest and hold with the other arm for 30 seconds. Switch arms.", duration: 60, gifName: "shoulder_stretch")
            ]
        case .intermediate:
            return [
                Exercise(name: "Standing Forward Fold", description: "Stand with feet hip-width apart and fold forward, letting your arms hang. Hold for 45 seconds.", duration: 45, gifName: "forward_fold"),
                Exercise(name: "Quad Stretch", description: "Stand on one leg and pull the other heel toward your glutes. Hold for 30 seconds and switch legs.", duration: 60, gifName: "quad_stretch"),
                Exercise(name: "Chest Opener", description: "Clasp hands behind your back and lift slightly while opening chest. Hold for 45 seconds.", duration: 45, gifName: "chest_opener")
            ]
        case .advanced:
            return [
                Exercise(name: "Pigeon Pose", description: "From a plank position, bring one leg forward in a figure-4 position. Hold for 60 seconds and switch sides.", duration: 120, gifName: "pigeon_pose"),
                Exercise(name: "Seated Spinal Twist", description: "Sit with one leg extended and the other bent across it. Twist toward the bent knee. Hold for 45 seconds and switch.", duration: 90, gifName: "spinal_twist"),
                Exercise(name: "Butterfly Stretch", description: "Sit with feet together and gently press knees toward floor. Hold for 60 seconds.", duration: 60, gifName: "butterfly_stretch")
            ]
        }
    }
}