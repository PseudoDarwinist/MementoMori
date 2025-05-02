import SwiftUI

struct ProfileView: View {
    // Add state objects for AppState and UserManager
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    // Add state for confirmation dialog
    @State private var showingResetConfirmation = false
    
    var body: some View {
        MainContainer {
            VStack(spacing: 2.remToPt()) {
                // Header
                Text("PROFILE")
                    .headingStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 0.5.remToPt())
                
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
                        
                        // Name - Use the actual name from user profile
                        Text(userManager.userProfile.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        // Basic info - Format the actual birth date
                        Text("Born: \(formattedBirthDate)")
                            .font(.system(size: 16))
                            .foregroundColor(ColorTheme.textSecondary)
                    }
                    .padding(2.remToPt())
                    .glassMorphism(cornerRadius: 1.remToPt(), opacity: 0.15)
                    
                    // Life data
                    VStack(alignment: .leading, spacing: 1.5.remToPt()) {
                        SectionHeader(title: "LIFE DATA")
                        
                        // Life expectancy - Use actual value
                        ProfileDataRow(
                            icon: "hourglass",
                            title: "Life Expectancy",
                            value: "\(userManager.userProfile.lifeExpectancy) years"
                        )
                        
                        // Age - Calculate from birth date
                        ProfileDataRow(
                            icon: "calendar",
                            title: "Current Age",
                            value: "\(currentAge) years"
                        )
                        
                        // Remaining - Calculate from expectancy and age
                        ProfileDataRow(
                            icon: "clock",
                            title: "Time Remaining",
                            value: "≈ \(remainingYears) years"
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
                        
                        // Display name - Use actual timer name
                        ProfileDataRow(
                            icon: "textformat",
                            title: "Display Name",
                            value: userManager.userProfile.timerName
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
                
                Spacer(minLength: 2.remToPt())
                
                // Button group
                VStack(spacing: 1.remToPt()) {
                    // Edit button
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Edit Profile")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ColorTheme.accentPrimary)
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                    
                    // Reset onboarding button (for testing)
                    Button(action: {
                        showingResetConfirmation = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text("Reset Onboarding")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ColorTheme.cardBackground)
                        .foregroundColor(ColorTheme.textSecondary)
                        .cornerRadius(25)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                    }
                    .confirmationDialog(
                        "Reset Onboarding",
                        isPresented: $showingResetConfirmation,
                        titleVisibility: .visible
                    ) {
                        Button("Reset", role: .destructive) {
                            appState.resetOnboarding()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("This will restart the onboarding process. Your data will be preserved.")
                    }
                }
            }
            .frame(maxWidth: 800)
        }
    }
    
    // MARK: - Computed Properties
    
    /// Format the birth date for display
    private var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: userManager.userProfile.birthDate)
    }
    
    /// Calculate current age in years
    private var currentAge: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: userManager.userProfile.birthDate, to: Date())
        return ageComponents.year ?? 0
    }
    
    /// Calculate remaining years based on life expectancy
    private var remainingYears: Int {
        let remaining = userManager.userProfile.lifeExpectancy - currentAge
        return max(0, remaining)
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