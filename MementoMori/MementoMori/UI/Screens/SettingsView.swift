import SwiftUI

/// Settings screen for the app
struct SettingsView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    // Form values
    @State private var name: String = ""
    @State private var timerName: String = ""
    @State private var birthDate: Date = Date()
    @State private var lifeExpectancy: Double = 90
    @State private var requiresAuthentication: Bool = false
    @State private var usesReducedMotion: Bool = false
    
    // UI states
    @State private var showingSaveConfirmation = false
    @State private var showingResetConfirmation = false
    @State private var isEditingEnabled = false
    
    // Range for life expectancy slider
    private let minExpectancy: Double = 50
    private let maxExpectancy: Double = 120
    
    // Character limit for names
    private let nameCharacterLimit = 30
    
    // MARK: - Body
    
    var body: some View {
        MainContainer {
            VStack(spacing: 2.remToPt()) {
                // Header
                Text("SETTINGS")
                    .headingStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 0.5.remToPt())
                
                // Settings form
                VStack(spacing: 1.5.remToPt()) {
                    // Personal Information section
                    SettingsSectionView(title: "PERSONAL INFORMATION") {
                        VStack(spacing: 1.remToPt()) {
                            // User name field
                            SettingsFieldView(
                                icon: "person.fill",
                                title: "Your Name",
                                isEditable: isEditingEnabled
                            ) {
                                if isEditingEnabled {
                                    TextField("Your Name", text: $name)
                                        .textFieldStyle(SettingsTextFieldStyle())
                                        .onChange(of: name) { oldValue, newValue in
                                            if newValue.count > nameCharacterLimit {
                                                name = String(newValue.prefix(nameCharacterLimit))
                                            }
                                        }
                                } else {
                                    Text(name)
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                            
                            // Birth date field
                            SettingsFieldView(
                                icon: "calendar",
                                title: "Birth Date",
                                isEditable: isEditingEnabled
                            ) {
                                if isEditingEnabled {
                                    DatePicker("", selection: $birthDate, in: ...Date(), displayedComponents: .date)
                                        .labelsHidden()
                                        .datePickerStyle(.compact)
                                } else {
                                    Text(formattedBirthDate)
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                            
                            // Life expectancy field
                            SettingsFieldView(
                                icon: "hourglass",
                                title: "Life Expectancy",
                                isEditable: isEditingEnabled
                            ) {
                                if isEditingEnabled {
                                    HStack {
                                        Slider(value: $lifeExpectancy, in: minExpectancy...maxExpectancy, step: 1)
                                            .tint(ColorTheme.accentPrimary)
                                        
                                        Text("\(Int(lifeExpectancy)) years")
                                            .foregroundColor(ColorTheme.textSecondary)
                                            .frame(width: 80)
                                    }
                                } else {
                                    Text("\(Int(lifeExpectancy)) years")
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                        }
                    }
                    
                    // Timer Settings section
                    SettingsSectionView(title: "TIMER SETTINGS") {
                        VStack(spacing: 1.remToPt()) {
                            // Timer name field
                            SettingsFieldView(
                                icon: "timer",
                                title: "Timer Name",
                                isEditable: isEditingEnabled
                            ) {
                                if isEditingEnabled {
                                    TextField("Timer Name", text: $timerName)
                                        .textFieldStyle(SettingsTextFieldStyle())
                                        .onChange(of: timerName) { oldValue, newValue in
                                            if newValue.count > nameCharacterLimit {
                                                timerName = String(newValue.prefix(nameCharacterLimit))
                                            }
                                        }
                                } else {
                                    Text(timerName)
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                            }
                        }
                    }
                    
                    // Preferences section
                    SettingsSectionView(title: "PREFERENCES") {
                        VStack(spacing: 1.remToPt()) {
                            // Authentication toggle
                            SettingsToggleView(
                                icon: "lock.fill",
                                title: "Require Authentication",
                                isOn: $requiresAuthentication,
                                isEditable: isEditingEnabled
                            )
                            
                            // Reduced motion toggle
                            SettingsToggleView(
                                icon: "waveform",
                                title: "Reduced Motion",
                                isOn: $usesReducedMotion,
                                isEditable: isEditingEnabled
                            )
                        }
                    }
                    
                    // Developer Options (for testing)
                    SettingsSectionView(title: "DEVELOPER OPTIONS") {
                        VStack(spacing: 1.remToPt()) {
                            Button(action: {
                                showingResetConfirmation = true
                            }) {
                                HStack {
                                    Image(systemName: "arrow.counterclockwise")
                                        .foregroundColor(ColorTheme.accentPrimary)
                                    Text("Reset Onboarding")
                                        .foregroundColor(ColorTheme.textPrimary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 14))
                                        .foregroundColor(ColorTheme.textSecondary)
                                }
                                .padding()
                                .background(ColorTheme.cardBackground)
                                .cornerRadius(0.75.remToPt())
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
                    
                    // App information
                    VStack(spacing: 0.5.remToPt()) {
                        Text("Memento Mori")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                        
                        Text("Version 1.0 (Build 1)")
                            .font(.system(size: 14))
                            .foregroundColor(ColorTheme.textSecondary)
                        
                        Text("© 2025 Memento Mori")
                            .font(.system(size: 12))
                            .foregroundColor(ColorTheme.textSecondary.opacity(0.7))
                            .padding(.top, 0.5.remToPt())
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(ColorTheme.cardBackground.opacity(0.5))
                    .cornerRadius(0.75.remToPt())
                }
                .frame(maxWidth: 800)
                
                // Action buttons
                HStack(spacing: 1.remToPt()) {
                    // Cancel button
                    Button(action: {
                        // Cancel editing and reset form values
                        resetFormValues()
                        isEditingEnabled = false
                    }) {
                        Text("Cancel")
                            .foregroundColor(ColorTheme.textPrimary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.cardBackground)
                            .cornerRadius(25)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(ColorTheme.borderColor, lineWidth: 1)
                            )
                    }
                    .opacity(isEditingEnabled ? 1 : 0)
                    .disabled(!isEditingEnabled)
                    
                    // Edit/Save button
                    Button(action: {
                        if isEditingEnabled {
                            // Save changes
                            saveChanges()
                            isEditingEnabled = false
                            showingSaveConfirmation = true
                        } else {
                            // Enable editing mode
                            isEditingEnabled = true
                        }
                    }) {
                        Text(isEditingEnabled ? "Save Changes" : "Edit Settings")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ColorTheme.accentPrimary)
                            .cornerRadius(25)
                    }
                    .alert("Settings Saved", isPresented: $showingSaveConfirmation) {
                        Button("OK", role: .cancel) {}
                    } message: {
                        Text("Your settings have been updated successfully.")
                    }
                }
                .padding(.vertical, 1.remToPt())
            }
        }
        .onAppear {
            // Load current values from user profile
            loadUserProfileValues()
        }
    }
    
    // MARK: - Methods
    
    /// Load values from the user profile
    private func loadUserProfileValues() {
        name = userManager.userProfile.name
        timerName = userManager.userProfile.timerName
        birthDate = userManager.userProfile.birthDate
        lifeExpectancy = Double(userManager.userProfile.lifeExpectancy)
        requiresAuthentication = userManager.userProfile.requiresAuthentication
        usesReducedMotion = userManager.userProfile.usesReducedMotion
    }
    
    /// Reset form values to current user profile
    private func resetFormValues() {
        loadUserProfileValues()
    }
    
    /// Save changes to the user profile
    private func saveChanges() {
        // Validate and trim inputs
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedTimerName = timerName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        userManager.updateProfileFields(
            name: trimmedName.isEmpty ? "User" : trimmedName,
            birthDate: birthDate,
            lifeExpectancy: Int(lifeExpectancy),
            timerName: trimmedTimerName.isEmpty ? "My Life Timer" : trimmedTimerName,
            requiresAuthentication: requiresAuthentication,
            usesReducedMotion: usesReducedMotion
        )
    }
    
    /// Format the birth date for display
    private var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: birthDate)
    }
}

// MARK: - Helper Components

/// A styled section for settings
struct SettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.75.remToPt()) {
            // Section title
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorTheme.textSecondary)
                .tracking(0.1.remToPt())
                .padding(.horizontal, 0.5.remToPt())
            
            // Section content in a card
            content
                .padding(1.remToPt())
                .background(ColorTheme.cardBackground)
                .cornerRadius(1.remToPt())
                .overlay(
                    RoundedRectangle(cornerRadius: 1.remToPt())
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
        }
    }
}

/// A styled field for settings
struct SettingsFieldView<Content: View>: View {
    let icon: String
    let title: String
    let isEditable: Bool
    let content: Content
    
    init(icon: String, title: String, isEditable: Bool, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.title = title
        self.isEditable = isEditable
        self.content = content()
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 0.75.remToPt()) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isEditable ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
                .frame(width: 24, height: 24)
            
            // Title
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            // Content
            content
        }
        .padding(.vertical, 0.5.remToPt())
    }
}

/// A styled toggle for settings
struct SettingsToggleView: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let isEditable: Bool
    
    var body: some View {
        HStack(alignment: .center, spacing: 0.75.remToPt()) {
            // Icon
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(isEditable ? ColorTheme.accentPrimary : ColorTheme.textSecondary)
                .frame(width: 24, height: 24)
            
            // Title
            Text(title)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textPrimary)
            
            Spacer()
            
            // Toggle
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: ColorTheme.accentPrimary))
                .disabled(!isEditable)
        }
        .padding(.vertical, 0.5.remToPt())
    }
}

/// A styled text field for settings
struct SettingsTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 0.5.remToPt())
            .padding(.horizontal, 0.75.remToPt())
            .background(ColorTheme.panelBackground.opacity(0.3))
            .cornerRadius(0.5.remToPt())
            .overlay(
                RoundedRectangle(cornerRadius: 0.5.remToPt())
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
    }
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
} 