import SwiftUI

/// Component for displaying the timer digits
struct TimerDigits: View {
    // MARK: - Properties
    
    /// Time data to display
    let timeData: TimeData
    
    /// Whether to show seconds
    var showSeconds: Bool = false
    
    /// Whether to animate the days digit
    var animateDays: Bool = true
    
    /// Whether to use reduced motion
    var reducedMotion: Bool = false
    
    /// Animation state for pulse effect
    @State private var animationState: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Timer digits display - Vertical layout
            VStack(spacing: 0) {
                // Top: Days
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        // First row of day digits (2 digits)
                        Text(String(format: "%02d", timeData.daysRemaining / 100))
                            .font(.system(size: 110, weight: .heavy))
                            .foregroundColor(ColorTheme.textPrimary)
                            .timerTextStyle()
                    }
                    
                    // Second row of day digits (2 digits)
                    HStack(spacing: 0) {
                        Text(String(format: "%02d", timeData.daysRemaining % 100))
                            .font(.system(size: 110, weight: .heavy))
                            .foregroundColor(ColorTheme.textPrimary)
                            .timerTextStyle()
                    }
                }
                .padding(.leading, 20)
                
                // Middle: Hours:Minutes
                HStack(spacing: 15) {
                    // Hours
                    Text(timeData.formattedHoursRemaining)
                        .font(.system(size: 110, weight: .heavy))
                        .foregroundColor(ColorTheme.textPrimary)
                        .timerTextStyle()
                    
                    // Separator
                    Text(":")
                        .font(.system(size: 110, weight: .heavy))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    // Minutes
                    Text(timeData.formattedMinutesRemaining)
                        .font(.system(size: 110, weight: .heavy))
                        .foregroundColor(ColorTheme.textPrimary)
                        .timerTextStyle()
                }
                
                // Labels below digits
                HStack(spacing: 0) {
                    Text("DAYS")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(width: 120, alignment: .leading)
                        .padding(.leading, 25)
                    
                    Spacer()
                    
                    Text("HOURS")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(width: 100, alignment: .center)
                    
                    Spacer()
                    
                    Text("MINUTES")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(ColorTheme.textSecondary)
                        .frame(width: 120, alignment: .trailing)
                        .padding(.trailing, 25)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 1.remToPt())
            .padding(.vertical, 2.remToPt())
            
            // Progress bar
            ProgressBar(
                percentage: timeData.completionPercentage / 100,
                leftText: "\(timeData.formattedPercentage) COMPLETE",
                rightText: "EST. \(timeData.lifeExpectancy) YEARS"
            )
            .padding(.horizontal, 1.5.remToPt())
            .padding(.bottom, 1.remToPt())
        }
        .glassMorphism(cornerRadius: 1.5.remToPt(), opacity: 0.2)
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
                timeData: TimeData.sample(),
                showSeconds: false
            )
            .frame(width: 350)
        }
        .preferredColorScheme(.dark)
    }
} 