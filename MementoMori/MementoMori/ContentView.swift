//
//  ContentView.swift
//  MementoMori
//
//  Created by Chetan Singh on 2025-05-01.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Text("MEMENTO MORI")
                    .logoTextStyle()
                
                VStack(spacing: 15) {
                    Text("Color Theme")
                        .headingStyle()
                    
                    HStack(spacing: 20) {
                        ColorSwatch(color: ColorTheme.backgroundPrimary, name: "Primary")
                        ColorSwatch(color: ColorTheme.backgroundDeeper, name: "Deeper")
                        ColorSwatch(color: ColorTheme.backgroundDarkest, name: "Darkest")
                    }
                    
                    HStack(spacing: 20) {
                        ColorSwatch(color: ColorTheme.accentPrimary, name: "Accent")
                        ColorSwatch(color: ColorTheme.accentSecondary, name: "Secondary")
                        ColorSwatch(color: ColorTheme.textSecondary, name: "Text 70%")
                    }
                }
                .padding()
                .glassMorphism()
                
                VStack(spacing: 15) {
                    Text("Typography")
                        .headingStyle()
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Heading Style")
                            .headingStyle()
                        
                        Text("Body text style for longer content that spans multiple lines and needs to be readable.")
                            .font(FontTheme.body())
                        
                        Text("Secondary text style at 70% opacity")
                            .secondaryTextStyle()
                        
                        Text("Small text style (0.8rem)")
                            .smallTextStyle()
                        
                        Text("TIMER DISPLAY")
                            .timerTextStyle()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
                .padding()
                .cardStyle()
                
                VStack(spacing: 15) {
                    Text("UI Components")
                        .headingStyle()
                    
                    HStack(spacing: 20) {
                        Image(systemName: "house.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.textPrimary)
                            .interactiveButtonStyle()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.textPrimary)
                            .interactiveButtonStyle()
                        
                        Image(systemName: "book.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.textPrimary)
                            .interactiveButtonStyle()
                        
                        Image(systemName: "chart.bar.fill")
                            .font(.system(size: 20))
                            .foregroundColor(ColorTheme.textPrimary)
                            .interactiveButtonStyle()
                    }
                    
                    Text("Footer Text — Remember that you will die. Live accordingly.")
                        .smallTextStyle(uppercase: false, letterSpacing: 0.01)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                }
                .padding()
                .glassMorphism()
            }
            .padding()
        }
        .withBackgroundEffects()
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

#Preview {
    ContentView()
}
