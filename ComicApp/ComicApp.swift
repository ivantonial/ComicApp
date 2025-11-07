//
//  ComicApp.swift
//  ComicApp
//
//  Created by Ivan Tonial IP.TV on 07/10/25.
//

import AppCoordinator
import SwiftUI

@main
struct ComicApp: App {
    @StateObject private var coordinator = AppCoordinator()

    var body: some Scene {
        WindowGroup {
            coordinator.start()
                .preferredColorScheme(.dark)
        }
    }
}
