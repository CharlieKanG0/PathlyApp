//
//  PathlyApp.swift
//  Pathly
//
//  Created by Charlie Kang on 6/9/2025.
//

import SwiftUI

@main
struct PathlyApp: App {
    @StateObject private var container: AppContainer
    @StateObject private var coordinator: AppCoordinator

    init() {
        let container = AppContainer()
        _container = StateObject(wrappedValue: container)
        _coordinator = StateObject(wrappedValue: AppCoordinator(container: container))
    }

    var body: some Scene {
        WindowGroup {
            coordinator.startView()
                .environmentObject(container)
                .environmentObject(coordinator)
        }
    }
}
