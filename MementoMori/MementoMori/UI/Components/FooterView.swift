import SwiftUI

/// Footer component for screens
struct FooterView: View {
    // MARK: - Properties
    
    /// Custom text to display (defaults to app motto)
    var text: String = "Memento Mori — Remember that you will die. Live accordingly."
    
    /// Whether to show a line above the footer
    var showDivider: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0.5.remToPt()) {
            if showDivider {
                Divider()
                    .background(ColorTheme.borderColor)
                    .padding(.bottom, 1.remToPt())
            }
            
            Text(text)
                .font(.system(size: 0.8.remToPt()))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.vertical, 0.5.remToPt())
        }
        .padding(.vertical, 1.remToPt())
    }
}

// MARK: - View Extension

extension View {
    /// Add a footer to the view
    /// - Parameters:
    ///   - text: Custom text to display (defaults to app motto)
    ///   - showDivider: Whether to show a line above the footer
    /// - Returns: The view with a footer
    func withFooter(
        text: String = "Memento Mori — Remember that you will die. Live accordingly.",
        showDivider: Bool = true
    ) -> some View {
        VStack(spacing: 0) {
            self
            Spacer(minLength: 1.remToPt())
            FooterView(text: text, showDivider: showDivider)
        }
    }
}

// MARK: - Preview

#Preview {
    VStack {
        Text("Content")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        FooterView()
    }
    .padding()
    .background(ColorTheme.backgroundPrimary)
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
} 