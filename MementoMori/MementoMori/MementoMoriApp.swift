//
//  MementoMoriApp.swift
//  MementoMori
//
//  Created by Chetan Singh on 2025-05-01.
//

import SwiftUI

@main
struct MementoMoriApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.dark) // Force dark mode
                .tint(ColorTheme.accentPrimary) // Set tint color for interactive elements
        }
    }
}
