import SwiftUI
import UIKit

/// View modifier for applying app background effects
struct BackgroundEffectsModifier: ViewModifier {
    // MARK: - Properties
    
    /// Whether to use reduced effects for performance/accessibility
    @AppStorage("usesReducedMotion") var usesReducedMotion: Bool = false
    
    /// Whether the app is running on a lower performance device
    var isLowPerformanceDevice: Bool {
        // Simple detection - could be improved with more device detection
        #if os(iOS)
        let deviceModel = UIDevice.current.model
        return deviceModel.contains("iPod") || deviceModel.contains("iPad") && UIDevice.current.systemVersion.compare("14.0", options: .numeric) == .orderedAscending
        #else
        return false
        #endif
    }
    
    /// Whether to show reduced effects
    var shouldReduceEffects: Bool {
        usesReducedMotion || isLowPerformanceDevice
    }
    
    // MARK: - Body
    
    func body(content: Content) -> some View {
        ZStack {
            // Base background - pure black
            Color.black
                .ignoresSafeArea()
            
            // Cinematic vignette effect with radial gradient
            if !shouldReduceEffects {
                RadialGradient(
                    gradient: Gradient(
                        colors: [
                            Color(hex: "071B33"), // Center color specified
                            Color(hex: "071B33").opacity(0.7),
                            Color(hex: "071B33").opacity(0.4),
                            Color(hex: "071B33").opacity(0.1),
                            Color.clear
                        ]
                    ),
                    center: .center,
                    startRadius: 50,
                    endRadius: 800
                )
                .ignoresSafeArea()
            } else {
                // Simplified background for reduced effects
                Color(hex: "071B33").opacity(0.8)
                    .ignoresSafeArea()
            }
            
            // Red accent glow - top left (more subtle)
            if !shouldReduceEffects {
                Circle()
                    .fill(ColorTheme.accentPrimary)
                    .frame(width: 250, height: 250)
                    .position(x: -50, y: -50)
                    .blur(radius: 80)
                    .opacity(0.12)
                    .ignoresSafeArea()
            }
            
            // Blue accent glow - bottom right (more subtle)
            if !shouldReduceEffects {
                Circle()
                    .fill(ColorTheme.accentSecondary)
                    .frame(width: 350, height: 350)
                    .position(x: UIScreen.main.bounds.width + 50, y: UIScreen.main.bounds.height + 50)
                    .blur(radius: 80)
                    .opacity(0.12)
                    .ignoresSafeArea()
            }
            
            // Main content
            content
                .zIndex(10) // Ensure content is above background effects
        }
        // Apply all vendor prefixes for blur through SwiftUI's built-in handling
    }
}

// MARK: - View Extension

extension View {
    /// Apply background effects to the view
    func withBackgroundEffects() -> some View {
        self.modifier(BackgroundEffectsModifier())
    }
    
    /// Create a glass morphism effect for components
    /// - Parameters:
    ///   - cornerRadius: Corner radius of the glass panel
    ///   - opacity: Opacity of the background color
    /// - Returns: Modified view with glass effect
    func glassMorphism(cornerRadius: CGFloat = 1.5.remToPt(), opacity: CGFloat = 0.2) -> some View {
        self.background(
            ZStack {
                // Use the deeper blue with 20% opacity as specified
                Color(hex: "031429").opacity(opacity)
                
                // Add blur effect
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
    
    /// Create a view background with the specified opacity and blur
    /// - Parameters:
    ///   - opacity: Background opacity
    ///   - blur: Blur radius
    ///   - cornerRadius: Corner radius
    /// - Returns: Modified view
    func glassPanelBackground(opacity: CGFloat = 0.2, blur: CGFloat = 15, cornerRadius: CGFloat = 1.5.remToPt()) -> some View {
        self.background(
            ZStack {
                Color(hex: "031429")
                    .opacity(opacity)
                
                // Add blur effect
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