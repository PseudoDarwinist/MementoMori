import SwiftUI
import Combine

struct TimerView: View {
    // MARK: - Properties
    
    @ObservedObject private var userManager = UserManager.shared
    
    /// Timer for updating seconds
    @State private var timer: AnyCancellable?
    
    /// Whether to show detailed time (including hours, minutes, seconds)
    @State private var showDetailedTime: Bool = false
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Header
                Text(userManager.userProfile.timerName.uppercased())
                    .logoTextStyle()
                    .padding(.top, geometry.size.height * 0.1)
                    .padding(.bottom, geometry.size.height * 0.05)
                
                Spacer()
                
                // Timer display
                TimerDigits(
                    timeData: userManager.timeData,
                    showSeconds: showDetailedTime,
                    reducedMotion: userManager.userProfile.usesReducedMotion
                )
                .frame(width: min(geometry.size.width * 0.9, 400))
                .onTapGesture {
                    // Toggle detailed view on tap
                    withAnimation {
                        showDetailedTime.toggle()
                    }
                }
                
                Spacer()
                
                // Quote Container
                QuoteContainer()
                    .padding(.horizontal, 30)
                    .padding(.bottom, geometry.size.height * 0.1)
            }
            .frame(width: geometry.size.width)
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