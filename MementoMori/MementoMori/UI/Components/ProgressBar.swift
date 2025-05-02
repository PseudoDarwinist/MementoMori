import SwiftUI

/// Progress bar component for displaying completion percentage
struct ProgressBar: View {
    // MARK: - Properties
    
    /// Progress percentage (0.0 to 1.0)
    let percentage: Double
    
    /// Text to display on the left side
    var leftText: String = ""
    
    /// Text to display on the right side
    var rightText: String = ""
    
    /// Height of the progress bar
    var height: CGFloat = 4
    
    /// Corner radius for the progress bar
    var cornerRadius: CGFloat = 2
    
    /// Whether to animate the progress bar
    var animated: Bool = true
    
    /// Current progress state for animation
    @State private var progress: Double = 0
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0.5.remToPt()) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Capsule()
                        .fill(Color.white.opacity(0.1))
                        .frame(height: height)
                    
                    // Fill
                    let fillWidth = min(CGFloat(progress) * geometry.size.width, geometry.size.width)
                    
                    Capsule()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    ColorTheme.accentPrimary,
                                    ColorTheme.accentPrimary.opacity(0.7)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: max(0, fillWidth), height: height)
                }
            }
            .frame(height: height)
            
            // Labels
            if !leftText.isEmpty || !rightText.isEmpty {
                HStack {
                    if !leftText.isEmpty {
                        Text(leftText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    
                    Spacer()
                    
                    if !rightText.isEmpty {
                        Text(rightText)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                }
            }
        }
        .onAppear {
            // Start with zero and animate to the actual percentage
            if animated {
                withAnimation(.easeOut(duration: 1.0)) {
                    progress = percentage
                }
            } else {
                progress = percentage
            }
        }
        // Update progress when percentage changes
        .onChange(of: percentage) { oldValue, newValue in
            if animated {
                withAnimation(.easeOut(duration: 1.0)) {
                    progress = newValue
                }
            } else {
                progress = newValue
            }
        }
    }
}

// MARK: - Preview

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            ProgressBar(
                percentage: 0.27,
                leftText: "27% COMPLETE",
                rightText: "EST. 90 YEARS"
            )
            
            ProgressBar(
                percentage: 0.5,
                leftText: "50% COMPLETE",
                rightText: "EST. 80 YEARS"
            )
            
            ProgressBar(
                percentage: 0.75,
                leftText: "75% COMPLETE",
                rightText: "EST. 85 YEARS"
            )
        }
        .padding()
        .background(ColorTheme.backgroundPrimary)
        .preferredColorScheme(.dark)
    }
} 