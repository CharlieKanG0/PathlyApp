import Foundation

struct Plan: Codable {
    let id: UUID
    let userId: UUID
    let weeks: [Week]
    let createdAt: Date
    
    init(userId: UUID, weeks: [Week]) {
        self.id = UUID()
        self.userId = userId
        self.weeks = weeks
        self.createdAt = Date()
    }
}