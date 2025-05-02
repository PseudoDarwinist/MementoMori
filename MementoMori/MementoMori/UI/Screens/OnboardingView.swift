import SwiftUI

/// Main onboarding view that manages the flow of onboarding steps
struct OnboardingView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background
            ColorTheme.backgroundDarkest
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 0) {
                // Current step view
                currentStepView
                    .transition(.opacity)
                    .animation(.easeInOut, value: appState.currentOnboardingStep)
            }
            .padding()
        }
        .withBackgroundEffects()
    }
    
    // MARK: - Current Step View
    
    /// The current step of the onboarding process
    @ViewBuilder
    private var currentStepView: some View {
        switch appState.currentOnboardingStep {
        case .birthDate:
            BirthDateView()
        case .lifeExpectancy:
            LifeExpectancyView()
        case .timerName:
            TimerNameView()
        case .welcome:
            WelcomeView()
        }
    }
}

// MARK: - Birth Date View

/// View for capturing the user's birth date
struct BirthDateView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    @State private var birthDate = Calendar.current.date(byAdding: .year, value: -30, to: Date()) ?? Date()
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Current date for validation
    private let currentDate = Date()
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("WHEN WERE YOU BORN?")
                .headingStyle()
                .padding(.top, 2.remToPt())
            
            // Subtitle
            Text("This will be used to calculate your life timeline.")
                .foregroundColor(ColorTheme.textSecondary)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.bottom, 2.remToPt())
            
            // Privacy note
            Text("Your birth date is stored only on your device and is never shared.")
                .foregroundColor(ColorTheme.textSecondary.opacity(0.7))
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.bottom, 3.remToPt())
            
            // Date picker
            DatePicker("Select your birth date", selection: $birthDate, in: ...currentDate, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding()
                .background(ColorTheme.cardBackground)
                .cornerRadius(1.remToPt())
                .overlay(
                    RoundedRectangle(cornerRadius: 1.remToPt())
                        .stroke(ColorTheme.borderColor, lineWidth: 1)
                )
                .padding(.horizontal, 1.remToPt())
                .accessibilityLabel("Birth date selector")
                .accessibilityHint("Use this picker to select your birth date")
            
            // Display selected date in formatted style
            Text("Selected date: \(formattedDate)")
                .foregroundColor(ColorTheme.textSecondary)
                .font(.system(size: 16))
                .padding(.top, 1.remToPt())
            
            Spacer()
            
            // Buttons
            HStack(spacing: 2.remToPt()) {
                // Skip button
                Button(action: {
                    // Just use the default birth date and advance
                    advanceToNextStep()
                }) {
                    Text("Skip")
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(1.remToPt())
                        .overlay(
                            RoundedRectangle(cornerRadius: 1.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
                .accessibilityHint("Skip birth date selection and use a default value")
                
                // Continue button
                Button(action: {
                    validateAndContinue()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.accentPrimary)
                        .cornerRadius(1.remToPt())
                }
                .accessibilityHint("Save your birth date and continue to the next step")
            }
            .padding(.bottom, 2.remToPt())
        }
        .padding(2.remToPt())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Birth Date"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Helpers
    
    /// Formatted date for display
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: birthDate)
    }
    
    /// Validate the birth date and continue to the next step
    private func validateAndContinue() {
        // Validate birth date
        if birthDate > currentDate {
            showAlert = true
            alertMessage = "Birth date cannot be in the future."
            return
        }
        
        // Calculate age in years
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        guard let age = ageComponents.year else {
            showAlert = true
            alertMessage = "Could not calculate age from the selected date."
            return
        }
        
        // Check if age is reasonable
        if age > 120 {
            showAlert = true
            alertMessage = "Please enter a valid birth date. The selected date makes you over 120 years old."
            return
        }
        
        // Save the birth date
        userManager.updateProfileFields(birthDate: birthDate)
        
        // Continue to next step
        advanceToNextStep()
    }
    
    /// Advance to the next onboarding step
    private func advanceToNextStep() {
        withAnimation {
            _ = appState.advanceToNextOnboardingStep()
        }
    }
}

// MARK: - Life Expectancy View

/// View for setting the user's expected life span
struct LifeExpectancyView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    // Default life expectancy based on global average
    @State private var lifeExpectancy: Double = 90.0
    
    // Range for the slider
    private let minExpectancy: Double = 50.0
    private let maxExpectancy: Double = 120.0
    
    // Step value for the stepper
    private let stepValue: Double = 1.0
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("LIFE EXPECTANCY")
                .headingStyle()
                .padding(.top, 2.remToPt())
            
            // Subtitle
            Text("Set your estimated life expectancy")
                .foregroundColor(ColorTheme.textSecondary)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.bottom, 1.remToPt())
            
            // More info
            Text("This is used to calculate your remaining time. You can change this value later.")
                .foregroundColor(ColorTheme.textSecondary.opacity(0.7))
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.bottom, 3.remToPt())
            
            // Current value display
            Text("\(Int(lifeExpectancy)) years")
                .font(.system(size: 48, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.bottom, 1.remToPt())
            
            // Slider
            VStack(spacing: 0.5.remToPt()) {
                // Slider control
                Slider(value: $lifeExpectancy, in: minExpectancy...maxExpectancy, step: stepValue)
                    .tint(ColorTheme.accentPrimary)
                    .padding(.horizontal)
                    .accessibilityLabel("Life expectancy slider")
                    .accessibilityValue("\(Int(lifeExpectancy)) years")
                
                // Min/max labels
                HStack {
                    Text("\(Int(minExpectancy))")
                        .font(.system(size: 12))
                        .foregroundColor(ColorTheme.textSecondary)
                    
                    Spacer()
                    
                    Text("\(Int(maxExpectancy))")
                        .font(.system(size: 12))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(ColorTheme.cardBackground)
            .cornerRadius(1.remToPt())
            .overlay(
                RoundedRectangle(cornerRadius: 1.remToPt())
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
            .padding(.horizontal, 1.remToPt())
            
            // Stepper (alternative input)
            HStack {
                // Decrement button
                Button(action: {
                    if lifeExpectancy > minExpectancy {
                        lifeExpectancy -= stepValue
                    }
                }) {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.textSecondary)
                }
                .accessibilityLabel("Decrease life expectancy")
                
                Spacer()
                
                // Text input for direct editing (simple alternative to TextField for precision)
                Button(action: {
                    // In a real implementation, this would show a numeric input field
                    // For now, we'll just keep the slider/stepper values
                }) {
                    Text("\(Int(lifeExpectancy)) years")
                        .font(.system(size: 16))
                        .foregroundColor(ColorTheme.textPrimary)
                        .padding(.vertical, 0.5.remToPt())
                        .padding(.horizontal, 1.remToPt())
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(0.5.remToPt())
                        .overlay(
                            RoundedRectangle(cornerRadius: 0.5.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
                .accessibilityLabel("Edit life expectancy directly")
                
                Spacer()
                
                // Increment button
                Button(action: {
                    if lifeExpectancy < maxExpectancy {
                        lifeExpectancy += stepValue
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(ColorTheme.accentPrimary)
                }
                .accessibilityLabel("Increase life expectancy")
            }
            .padding(.horizontal, 2.remToPt())
            .padding(.top, 1.remToPt())
            
            // Statistical note
            VStack(spacing: 0.5.remToPt()) {
                Text("Statistical Information")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorTheme.textPrimary)
                
                Text("The global average life expectancy is 73 years. Life expectancy varies by country, gender, and other factors.")
                    .font(.system(size: 14))
                    .foregroundColor(ColorTheme.textSecondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(ColorTheme.cardBackground.opacity(0.5))
            .cornerRadius(0.75.remToPt())
            .padding(.horizontal, 1.remToPt())
            .padding(.top, 2.remToPt())
            
            Spacer()
            
            // Buttons
            HStack(spacing: 2.remToPt()) {
                // Back button
                Button(action: {
                    goToPreviousStep()
                }) {
                    Text("Back")
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(1.remToPt())
                        .overlay(
                            RoundedRectangle(cornerRadius: 1.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
                .accessibilityHint("Go back to the previous step")
                
                // Continue button
                Button(action: {
                    saveAndContinue()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.accentPrimary)
                        .cornerRadius(1.remToPt())
                }
                .accessibilityHint("Save your life expectancy and continue to the next step")
            }
            .padding(.bottom, 2.remToPt())
        }
        .padding(2.remToPt())
        .onAppear {
            // Set initial value from user profile - use explicit Double conversion
            lifeExpectancy = Double(userManager.userProfile.lifeExpectancy)
        }
    }
    
    // MARK: - Actions
    
    /// Save the life expectancy and continue to the next step
    private func saveAndContinue() {
        // Update the user profile - use explicit Int conversion
        userManager.updateProfileFields(lifeExpectancy: Int(lifeExpectancy))
        
        // Continue to next step
        advanceToNextStep()
    }
    
    /// Advance to the next onboarding step
    private func advanceToNextStep() {
        withAnimation {
            _ = appState.advanceToNextOnboardingStep()
        }
    }
    
    /// Go back to the previous onboarding step
    private func goToPreviousStep() {
        withAnimation {
            _ = appState.moveToPreviousOnboardingStep()
        }
    }
}

// MARK: - Timer Name View

/// View for personalizing the timer name
struct TimerNameView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    // Timer name with default value
    @State private var timerName = "My Life Timer"
    
    // Character limit for the timer name
    private let characterLimit = 30
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("NAME YOUR TIMER")
                .headingStyle()
                .padding(.top, 2.remToPt())
            
            // Subtitle
            Text("Personalize your life countdown timer")
                .foregroundColor(ColorTheme.textSecondary)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .padding(.bottom, 1.remToPt())
            
            // More info
            Text("This name will appear above your countdown timer. You can change it later.")
                .foregroundColor(ColorTheme.textSecondary.opacity(0.7))
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
                .padding(.bottom, 3.remToPt())
            
            // Preview
            VStack(spacing: 0.5.remToPt()) {
                Text("PREVIEW")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
                    .tracking(0.15.remToPt())
                
                Text(timerName.isEmpty ? "My Life Timer" : timerName)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(ColorTheme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(ColorTheme.cardBackground)
            .cornerRadius(1.remToPt())
            .overlay(
                RoundedRectangle(cornerRadius: 1.remToPt())
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
            .padding(.horizontal, 1.remToPt())
            
            // Name input field
            VStack(alignment: .leading, spacing: 0.5.remToPt()) {
                Text("Timer Name")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
                
                TextField("Enter a name for your timer", text: $timerName)
                    .font(.system(size: 16))
                    .padding()
                    .background(ColorTheme.cardBackground)
                    .cornerRadius(0.75.remToPt())
                    .overlay(
                        RoundedRectangle(cornerRadius: 0.75.remToPt())
                            .stroke(ColorTheme.borderColor, lineWidth: 1)
                    )
                    .onChange(of: timerName) { oldValue, newValue in
                        // Enforce character limit
                        if newValue.count > characterLimit {
                            timerName = String(newValue.prefix(characterLimit))
                        }
                    }
                
                // Character count
                HStack {
                    Spacer()
                    Text("\(timerName.count)/\(characterLimit)")
                        .font(.system(size: 12))
                        .foregroundColor(timerName.count > Int(Double(characterLimit) * 0.8) 
                                          ? ColorTheme.accentPrimary 
                                          : ColorTheme.textSecondary)
                }
            }
            .padding()
            .background(ColorTheme.panelBackground.opacity(0.3))
            .cornerRadius(1.remToPt())
            .padding(.horizontal, 1.remToPt())
            .padding(.top, 2.remToPt())
            
            // Example suggestions
            VStack(alignment: .leading, spacing: 0.5.remToPt()) {
                Text("SUGGESTIONS")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(ColorTheme.textSecondary)
                    .tracking(0.15.remToPt())
                
                // Suggestion buttons
                VStack(spacing: 0.5.remToPt()) {
                    SuggestionButton(suggestion: "My Journey", currentName: $timerName)
                    SuggestionButton(suggestion: "Life Countdown", currentName: $timerName)
                    SuggestionButton(suggestion: "Memento Mori", currentName: $timerName)
                    SuggestionButton(suggestion: "Carpe Diem", currentName: $timerName)
                }
            }
            .padding()
            .background(ColorTheme.cardBackground.opacity(0.5))
            .cornerRadius(0.75.remToPt())
            .padding(.horizontal, 1.remToPt())
            .padding(.top, 1.remToPt())
            
            Spacer()
            
            // Buttons
            HStack(spacing: 2.remToPt()) {
                // Back button
                Button(action: {
                    goToPreviousStep()
                }) {
                    Text("Back")
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(1.remToPt())
                        .overlay(
                            RoundedRectangle(cornerRadius: 1.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
                .accessibilityHint("Go back to the previous step")
                
                // Continue button
                Button(action: {
                    saveAndContinue()
                }) {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.accentPrimary)
                        .cornerRadius(1.remToPt())
                }
                .accessibilityHint("Save your timer name and continue")
            }
            .padding(.bottom, 2.remToPt())
        }
        .padding(2.remToPt())
        .onAppear {
            // Set initial value from user profile
            timerName = userManager.userProfile.timerName
        }
    }
    
    // MARK: - Actions
    
    /// Save the timer name and continue to the next step
    private func saveAndContinue() {
        // Use default name if empty
        let nameToSave = timerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty 
            ? "My Life Timer" 
            : timerName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Update the user profile
        userManager.updateProfileFields(timerName: nameToSave)
        
        // Continue to next step
        advanceToNextStep()
    }
    
    /// Advance to the next onboarding step
    private func advanceToNextStep() {
        withAnimation {
            _ = appState.advanceToNextOnboardingStep()
        }
    }
    
    /// Go back to the previous onboarding step
    private func goToPreviousStep() {
        withAnimation {
            _ = appState.moveToPreviousOnboardingStep()
        }
    }
}

// MARK: - Suggestion Button

/// Button for suggesting timer names
struct SuggestionButton: View {
    let suggestion: String
    @Binding var currentName: String
    
    var body: some View {
        Button(action: {
            currentName = suggestion
        }) {
            Text(suggestion)
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.vertical, 0.5.remToPt())
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Welcome View

/// Final welcome screen of the onboarding process
struct WelcomeView: View {
    // MARK: - Properties
    
    @StateObject private var appState = AppState.shared
    @ObservedObject private var userManager = UserManager.shared
    
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("WELCOME TO MEMENTO MORI")
                .headingStyle()
                .padding(.top, 2.remToPt())
            
            // Subtitle with name
            Text("Hello, \(userManager.userProfile.name)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
                .padding(.top, 1.remToPt())
            
            // Quote
            Text("\"Remember that you will die. Live accordingly.\"")
                .font(.system(size: 18, weight: .light, design: .serif))
                .italic()
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, 1.remToPt())
                .padding(.bottom, 3.remToPt())
            
            // Summary
            VStack(spacing: 1.5.remToPt()) {
                SummaryRow(
                    icon: "calendar",
                    title: "Birth Date",
                    value: formattedBirthDate
                )
                
                SummaryRow(
                    icon: "hourglass",
                    title: "Life Expectancy",
                    value: "\(userManager.userProfile.lifeExpectancy) years"
                )
                
                SummaryRow(
                    icon: "timer",
                    title: "Timer Name",
                    value: userManager.userProfile.timerName
                )
            }
            .padding()
            .background(ColorTheme.cardBackground)
            .cornerRadius(1.remToPt())
            .overlay(
                RoundedRectangle(cornerRadius: 1.remToPt())
                    .stroke(ColorTheme.borderColor, lineWidth: 1)
            )
            .padding(.horizontal, 1.remToPt())
            
            // Description
            Text("Your life is measured in days, hours, minutes, and seconds. The timer on the next screen will show you exactly how much time you have remaining, based on statistical life expectancy.")
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .padding(.top, 1.remToPt())
            
            Spacer()
            
            // Buttons
            HStack(spacing: 2.remToPt()) {
                // Back button
                Button(action: {
                    goToPreviousStep()
                }) {
                    Text("Back")
                        .foregroundColor(ColorTheme.textSecondary)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.cardBackground)
                        .cornerRadius(1.remToPt())
                        .overlay(
                            RoundedRectangle(cornerRadius: 1.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
                .accessibilityHint("Go back to the previous step")
                
                // Begin button
                Button(action: {
                    completeOnboarding()
                }) {
                    Text("Begin")
                        .foregroundColor(.white)
                        .padding(.vertical, 0.8.remToPt())
                        .padding(.horizontal, 1.5.remToPt())
                        .background(ColorTheme.accentPrimary)
                        .cornerRadius(1.remToPt())
                }
                .accessibilityHint("Complete onboarding and start using the app")
            }
            .padding(.bottom, 2.remToPt())
        }
        .padding(2.remToPt())
    }
    
    // MARK: - Computed Properties
    
    /// Format the birth date for display
    private var formattedBirthDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: userManager.userProfile.birthDate)
    }
    
    // MARK: - Actions
    
    /// Complete the onboarding process
    private func completeOnboarding() {
        withAnimation {
            appState.completeOnboarding()
        }
    }
    
    /// Go back to the previous onboarding step
    private func goToPreviousStep() {
        withAnimation {
            _ = appState.moveToPreviousOnboardingStep()
        }
    }
}

/// Row for displaying a summary item
struct SummaryRow: View {
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .preferredColorScheme(.dark)
    }
} 