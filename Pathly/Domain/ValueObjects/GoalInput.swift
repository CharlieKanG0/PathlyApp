import Foundation

enum Goal: String, CaseIterable, Codable {
    case buildEndurance = "Build Endurance"
    case loseWeight = "Lose Weight"
    case run5K = "Run 5K"
    case run10K = "Run 10K"
    case halfMarathon = "Half Marathon"
    case marathon = "Marathon"
    
    var displayName: String {
        return self.rawValue
    }
}