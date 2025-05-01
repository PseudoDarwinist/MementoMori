import SwiftUI

/// Applies card styling to a view
struct CardStyle: ViewModifier {
    var cornerRadius: CGFloat = 1.0.remToPt()
    
    func body(content: Content) -> some View {
        content
            .padding(1.5.remToPt())
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(ColorTheme.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(ColorTheme.borderColor, lineWidth: 1)
                    )
                    .shadow(color: ColorTheme.shadowColor.opacity(0.3), radius: 20, x: 0, y: 4)
            )
    }
}

/// Applies interactive button styling to a view
struct InteractiveButtonStyle: ViewModifier {
    var size: CGFloat = 40
    var cornerRadius: CGFloat? = nil
    
    private var clipShape: AnyShape {
        if let radius = cornerRadius {
            return AnyShape(RoundedRectangle(cornerRadius: radius))
        } else {
            return AnyShape(Circle())
        }
    }
    
    private var strokeShape: AnyShape {
        if let radius = cornerRadius {
            return AnyShape(RoundedRectangle(cornerRadius: radius))
        } else {
            return AnyShape(Circle())
        }
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
            .background(ColorTheme.buttonBackground)
            .clipShape(clipShape)
            .overlay(
                strokeShape.stroke(ColorTheme.borderColor, lineWidth: 1)
            )
            .contentShape(clipShape)
            .hoverEffect(.highlight)
    }
}

/// Shape wrapper for type erasure
struct AnyShape: Shape {
    private let builder: @Sendable (CGRect) -> Path
    
    init<S: Shape>(_ shape: S) {
        builder = { rect in
            shape.path(in: rect)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        builder(rect)
    }
}

extension View {
    /// Apply card styling to view
    /// - Parameter cornerRadius: Corner radius in points
    /// - Returns: Modified view
    func cardStyle(cornerRadius: CGFloat = 1.0.remToPt()) -> some View {
        self.modifier(CardStyle(cornerRadius: cornerRadius))
    }
    
    /// Apply interactive button styling to view
    /// - Parameters:
    ///   - size: Size in points (width and height will be equal)
    ///   - cornerRadius: Optional corner radius. If nil, a circle will be used
    /// - Returns: Modified view
    func interactiveButtonStyle(size: CGFloat = 40, cornerRadius: CGFloat? = nil) -> some View {
        self.modifier(InteractiveButtonStyle(size: size, cornerRadius: cornerRadius))
    }
} 