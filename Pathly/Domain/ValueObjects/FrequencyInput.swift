import Foundation

enum Frequency: String, CaseIterable, Codable {
    case oneDay = "1 day per week"
    case twoDays = "2 days per week"
    case threeDays = "3 days per week"
    case fourDays = "4 days per week"
    case fiveDays = "5 days per week"
    case sixDays = "6 days per week"
    
    var displayName: String {
        return self.rawValue
    }
    
    var daysPerWeek: Int {
        switch self {
        case .oneDay: return 1
        case .twoDays: return 2
        case .threeDays: return 3
        case .fourDays: return 4
        case .fiveDays: return 5
        case .sixDays: return 6
        }
    }
}