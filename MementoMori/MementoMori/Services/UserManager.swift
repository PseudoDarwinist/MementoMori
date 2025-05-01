import Foundation
import Combine

/// Service for managing user profile data
final class UserManager: ObservableObject {
    // MARK: - Singleton
    
    static let shared = UserManager()
    
    // MARK: - Published Properties
    
    /// Current user profile
    @Published private(set) var userProfile: UserProfile
    
    /// Computed time data based on current profile
    @Published private(set) var timeData: TimeData
    
    // MARK: - Constants
    
    private enum Constants {
        static let userProfileKey = "com.mementomori.userProfile"
    }
    
    // MARK: - Private Properties
    
    private let timeCalculator = TimeCalculator.shared
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    private init() {
        // Initialize properties first - create temporary variables to avoid accessing self
        var profile: UserProfile
        var isNewProfile = false
        
        // Try to load saved profile
        if let data = UserDefaults.standard.data(forKey: Constants.userProfileKey) {
            do {
                let decoder = JSONDecoder()
                profile = try decoder.decode(UserProfile.self, from: data)
            } catch {
                print("Error loading user profile: \(error)")
                profile = UserProfile()
                isNewProfile = true
            }
        } else {
            profile = UserProfile()
            isNewProfile = true
        }
        
        // Keep local copies of needed values to avoid accessing self
        let birthDate = profile.birthDate
        let lifeExpectancy = profile.lifeExpectancy
        
        // Initialize properties in correct order
        self.userProfile = profile
        
        // Calculate initial time data using local variables
        self.timeData = TimeCalculator.shared.calculateTimeData(
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy
        )
        
        // Save the profile if it was created new
        if isNewProfile {
            saveUserProfile()
        }
    }
    
    // MARK: - Public Methods
    
    /// Update the user profile
    /// - Parameter profile: New user profile
    func updateProfile(_ profile: UserProfile) {
        self.userProfile = profile
        self.userProfile.lastUpdated = Date()
        
        // Save profile to storage
        saveUserProfile()
        
        // Recalculate time data
        self.timeData = timeCalculator.calculateTimeData(
            birthDate: profile.birthDate,
            lifeExpectancy: profile.lifeExpectancy,
            forceFresh: true
        )
    }
    
    /// Update specific user profile fields
    /// - Parameters:
    ///   - name: New name (optional)
    ///   - birthDate: New birth date (optional)
    ///   - lifeExpectancy: New life expectancy (optional)
    ///   - timerName: New timer name (optional)
    ///   - requiresAuthentication: New authentication requirement (optional)
    ///   - usesReducedMotion: New reduced motion setting (optional)
    func updateProfileFields(
        name: String? = nil,
        birthDate: Date? = nil,
        lifeExpectancy: Int? = nil,
        timerName: String? = nil,
        requiresAuthentication: Bool? = nil,
        usesReducedMotion: Bool? = nil
    ) {
        var updated = false
        var needsTimeRecalculation = false
        
        if let name = name, name != userProfile.name {
            userProfile.name = name
            updated = true
        }
        
        if let birthDate = birthDate, birthDate != userProfile.birthDate {
            userProfile.birthDate = birthDate
            updated = true
            needsTimeRecalculation = true
        }
        
        if let lifeExpectancy = lifeExpectancy, lifeExpectancy != userProfile.lifeExpectancy {
            userProfile.lifeExpectancy = lifeExpectancy
            updated = true
            needsTimeRecalculation = true
        }
        
        if let timerName = timerName, timerName != userProfile.timerName {
            userProfile.timerName = timerName
            updated = true
        }
        
        if let requiresAuthentication = requiresAuthentication, 
           requiresAuthentication != userProfile.requiresAuthentication {
            userProfile.requiresAuthentication = requiresAuthentication
            updated = true
        }
        
        if let usesReducedMotion = usesReducedMotion,
           usesReducedMotion != userProfile.usesReducedMotion {
            userProfile.usesReducedMotion = usesReducedMotion
            updated = true
        }
        
        if updated {
            userProfile.lastUpdated = Date()
            saveUserProfile()
            
            if needsTimeRecalculation {
                self.timeData = timeCalculator.calculateTimeData(
                    birthDate: userProfile.birthDate,
                    lifeExpectancy: userProfile.lifeExpectancy,
                    forceFresh: true
                )
            }
        }
    }
    
    /// Refresh time data calculation
    /// - Parameter updateSecondsOnly: Whether to only update seconds (for real-time updating)
    func refreshTimeData(updateSecondsOnly: Bool = false) {
        if updateSecondsOnly {
            self.timeData = timeCalculator.updateSeconds(timeData: timeData)
        } else {
            self.timeData = timeCalculator.calculateTimeData(
                birthDate: userProfile.birthDate,
                lifeExpectancy: userProfile.lifeExpectancy
            )
        }
    }
    
    /// Reset user profile to default values
    func resetProfile() {
        self.userProfile = UserProfile()
        saveUserProfile()
        
        self.timeData = timeCalculator.calculateTimeData(
            birthDate: userProfile.birthDate,
            lifeExpectancy: userProfile.lifeExpectancy,
            forceFresh: true
        )
    }
    
    // MARK: - Private Methods
    
    /// Load user profile from storage
    /// - Returns: Loaded user profile or nil if none exists
    private func loadUserProfile() -> UserProfile? {
        guard let data = userDefaults.data(forKey: Constants.userProfileKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(UserProfile.self, from: data)
        } catch {
            print("Error loading user profile: \(error)")
            return nil
        }
    }
    
    /// Save user profile to storage
    private func saveUserProfile() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(userProfile)
            userDefaults.set(data, forKey: Constants.userProfileKey)
        } catch {
            print("Error saving user profile: \(error)")
        }
    }
} 