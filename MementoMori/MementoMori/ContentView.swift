//
//  ContentView.swift
//  MementoMori
//
//  Created by Chetan Singh on 2025-05-01.
//

import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    
    // MARK: - Body
    
    var body: some View {
        MainView()
            .withBackgroundEffects()
            .preferredColorScheme(.dark) // Force dark mode
    }
}

struct ColorSwatch: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
            
            Text(name)
                .smallTextStyle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
