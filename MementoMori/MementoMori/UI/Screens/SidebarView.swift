import SwiftUI

/// Sidebar navigation component for the app
struct SidebarView: View {
    // MARK: - Properties
    
    /// Currently selected tab
    @Binding var selectedTab: NavigationTab
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .leading) {
            // Background with blur
            Color(UIColor(red: 3/255, green: 20/255, blue: 41/255, alpha: 0.2))
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Logo at top
                Text("MM")
                    .logoTextStyle()
                    .frame(width: 80, height: 80)
                    .padding(.top, 40)
                    .padding(.bottom, 60)
                
                // Navigation items
                VStack(spacing: 40) {
                    // Timer button
                    SidebarButton(
                        icon: NavigationTab.timer.icon,
                        isSelected: selectedTab == .timer,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .timer
                            }
                        }
                    )
                    
                    // Journal button
                    SidebarButton(
                        icon: NavigationTab.journal.icon,
                        isSelected: selectedTab == .journal,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .journal
                            }
                        }
                    )
                    
                    // Inspiration button
                    SidebarButton(
                        icon: NavigationTab.inspiration.icon,
                        isSelected: selectedTab == .inspiration,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .inspiration
                            }
                        }
                    )
                    
                    // Statistics button
                    SidebarButton(
                        icon: NavigationTab.statistics.icon,
                        isSelected: selectedTab == .statistics,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .statistics
                            }
                        }
                    )
                    
                    // Profile button
                    SidebarButton(
                        icon: NavigationTab.profile.icon,
                        isSelected: selectedTab == .profile,
                        action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                selectedTab = .profile
                            }
                        }
                    )
                }
                
                Spacer()
                
                // Settings button at bottom
                SidebarButton(
                    icon: "gearshape.fill",
                    isSelected: selectedTab == .settings,
                    action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedTab = .settings
                        }
                    }
                )
                .padding(.bottom, 40)
            }
            .frame(width: 80)
        }
        .frame(width: 80)
        .frame(maxHeight: .infinity)
        .overlay(
            Rectangle()
                .frame(width: 1)
                .foregroundColor(Color.white.opacity(0.05))
                .padding(.trailing, 0),
            alignment: .trailing
        )
    }
}

// MARK: - Sidebar Button Component

/// Button used in the sidebar for navigation
struct SidebarButton: View {
    // MARK: - Properties
    
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isSelected ? ColorTheme.accentPrimary.opacity(0.1) : Color.clear)
                    .frame(width: 48, height: 48)
                
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(isSelected ? ColorTheme.accentPrimary : ColorTheme.textPrimary)
            }
            .frame(width: 80, height: 48)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Navigation Tab Enum

/// Represents the main navigation tabs in the app
enum NavigationTab: CaseIterable {
    case timer
    case journal
    case inspiration
    case statistics
    case profile
    case settings
    
    var icon: String {
        switch self {
        case .timer:
            return "hourglass"
        case .journal:
            return "book.fill"
        case .inspiration:
            return "sparkles"
        case .statistics:
            return "chart.bar.fill"
        case .profile:
            return "person.fill"
        case .settings:
            return "gearshape.fill"
        }
    }
    
    var title: String {
        switch self {
        case .timer:
            return "Timer"
        case .journal:
            return "Journal"
        case .inspiration:
            return "Inspiration"
        case .statistics:
            return "Statistics"
        case .profile:
            return "Profile"
        case .settings:
            return "Settings"
        }
    }
}

// MARK: - Preview

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(selectedTab: .constant(.timer))
            .previewLayout(.fixed(width: 80, height: 800))
            .preferredColorScheme(.dark)
    }
} 