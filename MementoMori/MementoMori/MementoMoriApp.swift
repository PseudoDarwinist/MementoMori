//
//  MementoMoriApp.swift
//  MementoMori
//
//  Created by Chetan Singh on 2025-05-01.
//

import SwiftUI

@main
struct MementoMoriApp: App {
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        WindowGroup {
            if appState.hasCompletedOnboarding {
                // Main app
                MainView()
                    .preferredColorScheme(.dark) // Force dark mode
                    .tint(ColorTheme.accentPrimary) // Set tint color for interactive elements
            } else {
                // Onboarding flow
                OnboardingView()
                    .preferredColorScheme(.dark) // Force dark mode
                    .tint(ColorTheme.accentPrimary) // Set tint color for interactive elements
            }
        }
    }
}
