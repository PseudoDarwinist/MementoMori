import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("PROFILE")
                .headingStyle()
            
            // Profile content
            VStack(spacing: 2.remToPt()) {
                // Profile header
                VStack(spacing: 1.remToPt()) {
                    // Avatar
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    // Name
                    Text("John Doe")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(ColorTheme.textPrimary)
                    
                    // Basic info
                    Text("Born: January 1, 1990")
                        .font(.system(size: 16))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(2.remToPt())
                .glassMorphism(cornerRadius: 1.remToPt(), opacity: 0.15)
                
                // Life data
                VStack(alignment: .leading, spacing: 1.5.remToPt()) {
                    SectionHeader(title: "LIFE DATA")
                    
                    // Life expectancy
                    ProfileDataRow(
                        icon: "hourglass",
                        title: "Life Expectancy",
                        value: "90 years"
                    )
                    
                    // Age
                    ProfileDataRow(
                        icon: "calendar",
                        title: "Current Age",
                        value: "33 years"
                    )
                    
                    // Remaining
                    ProfileDataRow(
                        icon: "clock",
                        title: "Time Remaining",
                        value: "≈ 57 years"
                    )
                }
                .padding(1.5.remToPt())
                .background(ColorTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
                
                // Preferences
                VStack(alignment: .leading, spacing: 1.5.remToPt()) {
                    SectionHeader(title: "PREFERENCES")
                    
                    // Display name
                    ProfileDataRow(
                        icon: "textformat",
                        title: "Display Name",
                        value: "My Life Timer"
                    )
                    
                    // Theme
                    ProfileDataRow(
                        icon: "paintpalette",
                        title: "Theme",
                        value: "Dark"
                    )
                    
                    // Notifications
                    ProfileDataRow(
                        icon: "bell",
                        title: "Notifications",
                        value: "On"
                    )
                }
                .padding(1.5.remToPt())
                .background(ColorTheme.cardBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
            }
            .padding(.vertical, 1.remToPt())
            
            Spacer()
            
            // Edit button
            Button(action: {}) {
                HStack {
                    Image(systemName: "pencil")
                    Text("Edit Profile")
                }
                .padding()
                .background(ColorTheme.accentPrimary)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            .padding(.bottom, 1.remToPt())
        }
        .padding(2.remToPt())
    }
}

// MARK: - Helper Components

/// Section header for profile
struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(ColorTheme.textSecondary)
            .tracking(0.1.remToPt())
    }
}

/// Data row for profile information
struct ProfileDataRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.accentPrimary)
                .frame(width: 24, height: 24)
            
            // Title
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            // Value
            Text(value)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textSecondary)
        }
    }
}

// MARK: - Preview

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
            .background(ColorTheme.backgroundPrimary)
    }
} 