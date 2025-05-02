import Foundation
import SwiftUI

/// Application state manager
final class AppState: ObservableObject {
    // MARK: - Singleton
    
    static let shared = AppState()
    
    // MARK: - Published Properties
    
    /// Flag indicating whether onboarding has been completed
    @Published private(set) var hasCompletedOnboarding: Bool
    
    /// Current onboarding step
    @Published var currentOnboardingStep: OnboardingStep = .birthDate
    
    // MARK: - Constants
    
    private enum Constants {
        static let hasCompletedOnboardingKey = "com.mementomori.hasCompletedOnboarding"
    }
    
    // MARK: - Onboarding States
    
    /// Steps in the onboarding process
    enum OnboardingStep: Int, CaseIterable {
        case birthDate
        case lifeExpectancy
        case timerName
        case welcome
    }
    
    // MARK: - Initialization
    
    private init() {
        // Check if onboarding has been completed
        self.hasCompletedOnboarding = UserDefaults.standard.bool(forKey: Constants.hasCompletedOnboardingKey)
    }
    
    // MARK: - Public Methods
    
    /// Complete onboarding process
    func completeOnboarding() {
        self.hasCompletedOnboarding = true
        UserDefaults.standard.set(true, forKey: Constants.hasCompletedOnboardingKey)
    }
    
    /// Reset onboarding state (for testing or user reset)
    func resetOnboarding() {
        self.hasCompletedOnboarding = false
        self.currentOnboardingStep = .birthDate
        UserDefaults.standard.set(false, forKey: Constants.hasCompletedOnboardingKey)
    }
    
    /// Move to the next onboarding step
    /// - Returns: True if advanced to next step, false if at last step
    func advanceToNextOnboardingStep() -> Bool {
        let allSteps = OnboardingStep.allCases
        guard let currentIndex = allSteps.firstIndex(of: currentOnboardingStep),
              currentIndex < allSteps.count - 1 else {
            return false
        }
        
        currentOnboardingStep = allSteps[currentIndex + 1]
        return true
    }
    
    /// Move to the previous onboarding step
    /// - Returns: True if moved to previous step, false if at first step
    func moveToPreviousOnboardingStep() -> Bool {
        let allSteps = OnboardingStep.allCases
        guard let currentIndex = allSteps.firstIndex(of: currentOnboardingStep),
              currentIndex > 0 else {
            return false
        }
        
        currentOnboardingStep = allSteps[currentIndex - 1]
        return true
    }
} 