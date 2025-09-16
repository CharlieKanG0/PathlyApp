import Foundation

enum Experience: String, CaseIterable, Codable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
    
    var displayName: String {
        return self.rawValue
    }
}