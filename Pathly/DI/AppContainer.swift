import Foundation
import SwiftUI

/// Simple dependency container for the app. Expand with services as needed.
final class AppContainer: ObservableObject {
    // Add services here, e.g. networking, persistence, repositories

    // Example: app-wide configuration
    @Published var isFirstLaunch: Bool = true

    init() {
        // perform setup if needed
    }
}
