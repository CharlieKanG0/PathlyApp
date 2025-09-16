import Foundation

struct User: Codable {
    let id: UUID
    let goal: Goal
    let frequency: Frequency
    let experience: Experience
    let createdAt: Date
    
    init(goal: Goal, frequency: Frequency, experience: Experience) {
        self.id = UUID()
        self.goal = goal
        self.frequency = frequency
        self.experience = experience
        self.createdAt = Date()
    }
}