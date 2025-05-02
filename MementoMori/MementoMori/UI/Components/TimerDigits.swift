import SwiftUI

/// Component for displaying the timer digits
struct TimerDigits: View {
    // MARK: - Properties
    
    /// Time data to display
    let timeData: TimeData
    
    /// Whether to animate the days digit
    var animateDays: Bool = true
    
    /// Whether to use reduced motion
    var reducedMotion: Bool = false
    
    /// Animation state for pulse effect
    @State private var animationState: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0.5.remToPt()) {
            // Timer digits display - Compact horizontal layout
            HStack(spacing: 0.2.remToPt()) {
                // Days
                Text(String(format: "%d", timeData.daysRemaining))
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .timerTextStyle()
                    .scaleEffect(animateDays && !reducedMotion && animationState ? 1.02 : 1.0)
                
                // Separator after days
                Text(":")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                // Hours
                Text(timeData.formattedHoursRemaining)
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .timerTextStyle()
                
                // Separator after hours
                Text(":")
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                // Minutes
                Text(timeData.formattedMinutesRemaining)
                    .font(.system(size: 54, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .timerTextStyle()
            }
            .padding(.horizontal, 0.8.remToPt())
            .padding(.top, 1.2.remToPt())
            
            // Labels below digits
            HStack(spacing: 0) {
                Text("DAYS")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                
                Text("HOURS")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
                
                Text("MINUTES")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ColorTheme.textSecondary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 0.8.remToPt())
            
            // Progress bar
            ProgressBar(
                percentage: timeData.completionPercentage / 100,
                leftText: "\(timeData.formattedPercentage) COMPLETE",
                rightText: "EST. \(timeData.lifeExpectancy) YEARS"
            )
            .padding(.horizontal, 0.8.remToPt())
            .padding(.bottom, 0.8.remToPt())
        }
        .glassMorphism(cornerRadius: 1.2.remToPt(), opacity: 0.2)
        .onAppear {
            // Start animation when view appears
            if animateDays && !reducedMotion {
                withAnimation(
                    Animation.easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                ) {
                    animationState.toggle()
                }
            }
        }
    }
}

// MARK: - Preview

struct TimerDigits_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorTheme.backgroundPrimary.ignoresSafeArea()
            
            TimerDigits(
                timeData: TimeData.sample()
            )
            .frame(width: 350)
        }
        .preferredColorScheme(.dark)
    }
} 