import Foundation

struct Week: Codable {
    let id: UUID
    let weekNumber: Int
    let workouts: [Workout]
    
    init(weekNumber: Int, workouts: [Workout]) {
        self.id = UUID()
        self.weekNumber = weekNumber
        self.workouts = workouts
    }
}