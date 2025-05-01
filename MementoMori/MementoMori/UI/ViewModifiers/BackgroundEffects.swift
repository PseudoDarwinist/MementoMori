import SwiftUI
import UIKit

/// Applies the main app background effects
struct BackgroundEffects: ViewModifier {
    var includeGlowEffects: Bool = true
    var reducedMotion: Bool = false
    
    func body(content: Content) -> some View {
        ZStack {
            // Base background color
            ColorTheme.backgroundDarkest
                .ignoresSafeArea()
            
            // Radial gradient vignette
            RadialGradient(
                gradient: Gradient(colors: [
                    ColorTheme.backgroundPrimary.opacity(0.3),
                    ColorTheme.backgroundDarkest
                ]),
                center: .center,
                startRadius: 10,
                endRadius: 600
            )
            .ignoresSafeArea()
            
            if includeGlowEffects {
                // Red accent glow at top-left
                Circle()
                    .fill(ColorTheme.redGlow)
                    .frame(width: 350, height: 350)
                    .blur(radius: 80)
                    .position(x: UIScreen.main.bounds.width * 0.1, y: UIScreen.main.bounds.height * 0.1)
                    .opacity(reducedMotion ? 0.1 : 0.1)
                
                // Blue accent glow at bottom-right
                Circle()
                    .fill(ColorTheme.blueGlow)
                    .frame(width: 450, height: 450)
                    .blur(radius: 80)
                    .position(x: UIScreen.main.bounds.width * 0.9, y: UIScreen.main.bounds.height * 0.9)
                    .opacity(reducedMotion ? 0.1 : 0.1)
            }
            
            // Content
            content
        }
    }
}

extension View {
    /// Apply the main app background effects
    /// - Parameters:
    ///   - includeGlowEffects: Whether to include the accent glow effects
    ///   - reducedMotion: Whether to use reduced motion variant
    /// - Returns: Modified view
    func withBackgroundEffects(includeGlowEffects: Bool = true, reducedMotion: Bool = false) -> some View {
        self.modifier(BackgroundEffects(includeGlowEffects: includeGlowEffects, reducedMotion: reducedMotion))
    }
    
    /// Create a view background with the specified opacity and blur
    /// - Parameters:
    ///   - opacity: Background opacity
    ///   - blur: Blur radius
    ///   - cornerRadius: Corner radius
    /// - Returns: Modified view
    func glassPanelBackground(opacity: CGFloat = 0.2, blur: CGFloat = 15, cornerRadius: CGFloat = 1.5.remToPt()) -> some View {
        self.background(
            ZStack {
                ColorTheme.panelBackground
                    .opacity(opacity)
                
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .opacity(0.8)
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
        )
    }
} 