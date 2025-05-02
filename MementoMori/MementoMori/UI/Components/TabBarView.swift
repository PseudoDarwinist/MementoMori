import SwiftUI

/// Tab bar navigation component for the app
struct TabBarView: View {
    // MARK: - Properties
    
    /// Currently selected tab
    @Binding var selectedTab: NavigationTab
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background with blur - using the specified color #031429 with 20% opacity
            ZStack {
                Color(hex: "031429").opacity(0.2)
                
                // Add blur effect for the frosted look
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                    .opacity(0.8)
            }
            .frame(height: 60)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.white.opacity(0.03))
                    .offset(y: -0.5),
                alignment: .top
            )
            .ignoresSafeArea(edges: .bottom)
            
            // Tab items
            HStack(spacing: 0) {
                Spacer()
                
                // Timer tab
                TabBarButton(
                    icon: NavigationTab.timer.icon,
                    title: NavigationTab.timer.title,
                    isSelected: selectedTab == .timer,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .timer
                        }
                    }
                )
                
                Spacer()
                
                // Journal tab
                TabBarButton(
                    icon: NavigationTab.journal.icon,
                    title: NavigationTab.journal.title,
                    isSelected: selectedTab == .journal,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .journal
                        }
                    }
                )
                
                Spacer()
                
                // Statistics tab
                TabBarButton(
                    icon: NavigationTab.statistics.icon,
                    title: NavigationTab.statistics.title,
                    isSelected: selectedTab == .statistics,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .statistics
                        }
                    }
                )
                
                Spacer()
                
                // Profile tab
                TabBarButton(
                    icon: NavigationTab.profile.icon,
                    title: NavigationTab.profile.title,
                    isSelected: selectedTab == .profile,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .profile
                        }
                    }
                )
                
                Spacer()
                
                // Settings tab
                TabBarButton(
                    icon: NavigationTab.settings.icon,
                    title: NavigationTab.settings.title,
                    isSelected: selectedTab == .settings,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .settings
                        }
                    }
                )
                
                Spacer()
            }
            .padding(.vertical, 6)
            .frame(height: 60)
        }
    }
}

// MARK: - Tab Bar Button Component

/// Button used in the tab bar for navigation
struct TabBarButton: View {
    // MARK: - Properties
    
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
                
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
            }
            .frame(height: 48)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        VStack {
            Spacer()
            TabBarView(selectedTab: .constant(.timer))
        }
    }
} 