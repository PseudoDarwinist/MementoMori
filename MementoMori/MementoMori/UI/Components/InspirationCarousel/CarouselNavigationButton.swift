import SwiftUI

/// Button component for carousel navigation
struct CarouselNavigationButton: View {
    // MARK: - Properties
    
    /// SF Symbol name for the button icon
    let systemName: String
    
    /// Size of the button
    var size: CGFloat = 48
    
    /// Action to perform when the button is tapped
    let action: () -> Void
    
    // MARK: - State
    
    /// Whether the button is currently pressed
    @State private var isPressed = false
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            // Provide haptic feedback
            #if os(iOS)
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            #endif
            
            // Perform the action
            action()
        }) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: size, height: size)
                .background(
                    Circle()
                        .fill(Color.white.opacity(isPressed ? 0.2 : 0.1))
                )
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.05), lineWidth: 1)
                )
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .animation(.spring(response: 0.3), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .pressEvents(onPress: { isPressed = true }, onRelease: { isPressed = false })
        .accessibilityLabel(accessibilityLabel)
    }
    
    // MARK: - Helper Properties
    
    /// Accessibility label based on the button type
    private var accessibilityLabel: String {
        systemName.contains("left") ? "Previous slide" : "Next slide"
    }
}

// MARK: - Press Gesture Extension

extension View {
    /// Add press event handlers to a view
    /// - Parameters:
    ///   - onPress: Action to perform when pressed
    ///   - onRelease: Action to perform when released
    /// - Returns: Modified view with gesture
    func pressEvents(onPress: @escaping () -> Void, onRelease: @escaping () -> Void) -> some View {
        self.simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in onPress() }
                .onEnded { _ in onRelease() }
        )
    }
}

// MARK: - Preview

struct CarouselNavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.01, green: 0.05, blue: 0.15)
                .ignoresSafeArea()
            
            HStack(spacing: 32) {
                CarouselNavigationButton(systemName: "chevron.left") {
                    print("Previous")
                }
                
                CarouselNavigationButton(systemName: "chevron.right") {
                    print("Next")
                }
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
} 