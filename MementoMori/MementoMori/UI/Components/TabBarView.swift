import SwiftUI

/// TabBar navigation component for the app's bottom navigation
struct TabBarView: View {
    // MARK: - Properties
    
    /// Currently selected tab
    @Binding var selectedTab: NavigationTab
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background with blur
            Rectangle()
                .fill(Color(UIColor(red: 3/255, green: 20/255, blue: 41/255, alpha: 0.95)))
                .frame(height: 83)
                .background(
                    BackdropBlurView(style: .systemUltraThinMaterialDark)
                        .edgesIgnoringSafeArea(.bottom)
                )
                .overlay(
                    // Add top divider
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.white.opacity(0.1))
                        .padding(.bottom, 82),
                    alignment: .top
                )
            
            // Tab bar content
            HStack(spacing: 0) {
                ForEach(NavigationTab.allCases.filter { $0 != .settings }, id: \.self) { tab in
                    TabBarButton(
                        icon: tab.icon,
                        title: tab.title,
                        isSelected: selectedTab == tab,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        }
                    )
                }
                
                // Settings tab
                TabBarButton(
                    icon: NavigationTab.settings.icon,
                    title: NavigationTab.settings.title,
                    isSelected: selectedTab == .settings,
                    action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedTab = .settings
                        }
                    }
                )
            }
            .padding(.top, 5)
            .padding(.bottom, 25) // Add padding for safe area
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

// MARK: - TabBar Button Component

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
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
                
                Text(title)
                    .font(.system(size: 10))
                    .foregroundColor(isSelected ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Backdrop Blur View

/// UIViewRepresentable for UIKit blur effect
struct BackdropBlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

// MARK: - Preview

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            TabBarView(selectedTab: .constant(.timer))
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .preferredColorScheme(.dark)
    }
} 