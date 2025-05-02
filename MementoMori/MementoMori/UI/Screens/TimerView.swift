import SwiftUI
import Combine

struct TimerView: View {
    // MARK: - Properties
    
    @ObservedObject private var userManager = UserManager.shared
    
    /// Timer for updating seconds
    @State private var timer: AnyCancellable?
    
    // MARK: - Body
    
    var body: some View {
        MainContainer {
            VStack(spacing: 1.remToPt()) {
                // Header
                HeaderView(
                    title: userManager.userProfile.timerName,
                    actionButtons: [
                        HeaderActionButton(icon: "gearshape", action: { 
                            // TODO: Navigate to settings
                        })
                    ]
                )
                .padding(.bottom, 0.3.remToPt())
                
                // Timer display
                TimerDigits(
                    timeData: userManager.timeData,
                    reducedMotion: userManager.userProfile.usesReducedMotion
                )
                .frame(maxWidth: 420)
                
                // Quote Container
                QuoteContainer()
                    .frame(maxWidth: 650)
                    .padding(.vertical, 0.8.remToPt())
                
                // Daily Inspirations Carousel - expanded to fill remaining space
                InspirationCarousel()
                    .padding(.top, 0.3.remToPt())
                    .layoutPriority(1)
                    .frame(maxHeight: .infinity)
                
                // Removed Spacer since we want the carousel to expand
            }
        }
        .onAppear {
            // Refresh time data when view appears
            userManager.refreshTimeData()
            
            // Start timer for updating seconds
            startTimer()
        }
        .onDisappear {
            // Stop timer when view disappears
            stopTimer()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Start timer for updating seconds
    private func startTimer() {
        // Stop any existing timer
        stopTimer()
        
        // Create new timer that fires every second
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                // Update only seconds for performance
                userManager.refreshTimeData(updateSecondsOnly: true)
            }
    }
    
    /// Stop the timer
    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

// MARK: - Preview

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
            .preferredColorScheme(.dark)
            .background(ColorTheme.backgroundPrimary)
    }
} 