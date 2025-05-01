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
            
            // Main content area - fills the entire screen
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
            
            // Custom tab bar overlaid at bottom
            VStack {
                Spacer()
                TabBarView(selectedTab: $selectedTab)
            }
            .ignoresSafeArea(.keyboard)
        }
        .withBackgroundEffects()
    }
}

// MARK: - Settings View (placeholder)

/// Placeholder for the Settings screen
struct SettingsView: View {
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("SETTINGS")
                .headingStyle()
            
            // Settings content
            VStack(spacing: 1.5.remToPt()) {
                SettingsSectionHeader(title: "ACCOUNT")
                SettingsToggle(title: "iCloud Sync", isOn: true)
                SettingsToggle(title: "Data Backup", isOn: true)
                
                SettingsSectionHeader(title: "NOTIFICATIONS")
                SettingsToggle(title: "Daily Reminders", isOn: true)
                SettingsToggle(title: "Milestone Alerts", isOn: true)
                
                SettingsSectionHeader(title: "APPEARANCE")
                SettingsToggle(title: "Reduced Motion", isOn: false)
                SettingsToggle(title: "Use System Theme", isOn: false)
                
                SettingsSectionHeader(title: "PRIVACY")
                SettingsToggle(title: "Require Authentication", isOn: true)
                SettingsToggle(title: "Analytics", isOn: false)
            }
            .padding()
            .background(ColorTheme.cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
            
            Spacer()
            
            // Version info
            Text("Version 1.0.0 (Build 1)")
                .font(.system(size: 12))
                .foregroundColor(ColorTheme.textSecondary)
                .padding(.bottom, 85) // Add padding for tab bar
        }
        .padding(2.remToPt())
    }
}

// MARK: - Settings Components

/// Header for settings sections
struct SettingsSectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorTheme.textSecondary)
                .tracking(0.1.remToPt())
            
            Spacer()
        }
        .padding(.top, 1.remToPt())
    }
}

/// Toggle row for settings
struct SettingsToggle: View {
    let title: String
    @State var isOn: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: ColorTheme.accentPrimary))
        }
        .padding(.vertical, 0.5.remToPt())
    }
}

// MARK: - Preview

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .preferredColorScheme(.dark)
    }
} 