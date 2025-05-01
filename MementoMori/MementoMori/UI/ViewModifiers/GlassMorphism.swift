import SwiftUI
import UIKit

/// Creates a glass morphism effect for UI elements
struct GlassMorphism: ViewModifier {
    var cornerRadius: CGFloat = 1.5.remToPt()
    var opacity: CGFloat = 0.2
    var blurRadius: CGFloat = 15
    
    func body(content: Content) -> some View {
        content
            .background(
                ZStack {
                    ColorTheme.backgroundDeeper
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

/// UIViewRepresentable for UIVisualEffectView to create blur effects
struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect
    }
}

extension View {
    /// Apply glass morphism effect to a view
    /// - Parameters:
    ///   - cornerRadius: Corner radius in points
    ///   - opacity: Background opacity
    ///   - blurRadius: Blur radius
    /// - Returns: Modified view
    func glassMorphism(
        cornerRadius: CGFloat = 1.5.remToPt(),
        opacity: CGFloat = 0.2,
        blurRadius: CGFloat = 15
    ) -> some View {
        self.modifier(GlassMorphism(cornerRadius: cornerRadius, opacity: opacity, blurRadius: blurRadius))
    }
} 