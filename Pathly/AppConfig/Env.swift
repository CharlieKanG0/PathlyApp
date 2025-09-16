import Foundation

struct Env {
    static let isDebug: Bool = {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }()
    
    static let appName: String = "Pathly"
    
    // Add other environment variables as needed
}