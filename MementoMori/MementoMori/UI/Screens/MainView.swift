import SwiftUI

/// Main container view for the app
struct MainView: View {
    // MARK: - Properties
    
    /// Currently selected navigation tab
    @State private var selectedTab: NavigationTab = .timer
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            ColorTheme.backgroundDarkest
                .ignoresSafeArea()
            
            // Main content area with tab bar
            VStack(spacing: 0) {
                // Content area with tab views
                TabView(selection: $selectedTab) {
                    TimerView()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(NavigationTab.timer)
                    
                    JournalView()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(NavigationTab.journal)
                    
                    StatisticsView()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(NavigationTab.statistics)
                    
                    ProfileView()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(NavigationTab.profile)
                    
                    SettingsView()
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(NavigationTab.settings)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Tab bar at bottom
                TabBarView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
        .withBackgroundEffects()
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
} 