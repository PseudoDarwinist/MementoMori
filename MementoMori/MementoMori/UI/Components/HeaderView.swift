import SwiftUI

/// Header component for screens
struct HeaderView: View {
    // MARK: - Properties
    
    /// The title to display
    let title: String
    
    /// Optional action buttons to display
    var actionButtons: [HeaderActionButton]?
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            // Title
            Text(title.uppercased())
                .headingStyle()
            
            Spacer()
            
            // Action buttons
            if let buttons = actionButtons {
                HStack(spacing: 0.5.remToPt()) {
                    ForEach(buttons) { button in
                        Button(action: button.action) {
                            Image(systemName: button.icon)
                                .font(.system(size: 18))
                                .foregroundColor(ColorTheme.textPrimary)
                                .frame(width: 40, height: 40)
                                .background(ColorTheme.buttonBackground)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 1.remToPt())
    }
}

// MARK: - Header Action Button Model

/// Model for header action buttons
struct HeaderActionButton: Identifiable {
    /// Unique identifier
    let id = UUID()
    
    /// Icon name (SF Symbol)
    let icon: String
    
    /// Action to perform when tapped
    let action: () -> Void
}

// MARK: - Preview

#Preview {
    VStack(spacing: 1.remToPt()) {
        HeaderView(
            title: "Screen Title",
            actionButtons: [
                HeaderActionButton(icon: "gear", action: {}),
                HeaderActionButton(icon: "bell", action: {})
            ]
        )
        
        HeaderView(title: "Another Title")
    }
    .padding()
    .background(ColorTheme.backgroundPrimary)
    .previewLayout(.sizeThatFits)
    .preferredColorScheme(.dark)
} 