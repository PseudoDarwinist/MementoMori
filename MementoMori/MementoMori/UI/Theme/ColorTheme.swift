import SwiftUI

/// Color theme for the Memento Mori app
/// Contains all color definitions used throughout the app
enum ColorTheme {
    // MARK: - Background Colors
    static let backgroundPrimary = Color(hex: "071B33") // primary deep blue
    static let backgroundDeeper = Color(hex: "031429") // deeper blue 
    static let backgroundDarkest = Color(hex: "020C18") // darkest blue
    
    // MARK: - Text Colors
    static let textPrimary = Color.white // primary white
    static let textSecondary = Color.white.opacity(0.7) // 70% white
    
    // MARK: - Accent Colors
    static let accentPrimary = Color(hex: "E63946") // primary red
    static let accentSecondary = Color(hex: "4A63E7") // secondary blue
    
    // MARK: - UI Element Colors
    static let cardBackground = Color.white.opacity(0.05) // 5% white
    static let panelBackground = Color(hex: "031429").opacity(0.2) // 20% deeper blue
    static let borderColor = Color.white.opacity(0.03) // 3% white
    static let shadowColor = Color.black.opacity(0.2) // 20% black
    
    // MARK: - Button States
    static let buttonBackground = Color.white.opacity(0.05) // 5% white
    static let buttonBackgroundHover = Color.white.opacity(0.1) // 10% white
    static let buttonBackgroundActive = accentPrimary
    
    // MARK: - Glow Effects
    static let redGlow = accentPrimary.opacity(0.15) // 15% opacity for glow effect
    static let blueGlow = accentSecondary.opacity(0.15) // 15% opacity for glow effect
} 