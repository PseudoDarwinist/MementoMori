import Foundation

/// Model representing user profile data
struct UserProfile: Codable, Equatable {
    // MARK: - Properties
    
    /// Unique identifier for the user
    var id: UUID
    
    /// User's full name
    var name: String
    
    /// User's birth date
    var birthDate: Date
    
    /// User's expected life span in years
    var lifeExpectancy: Int
    
    /// Custom display name for the timer
    var timerName: String
    
    /// Whether biometric authentication is required
    var requiresAuthentication: Bool
    
    /// Whether to use reduced motion for animations
    var usesReducedMotion: Bool
    
    /// Date when the profile was last updated
    var lastUpdated: Date
    
    // MARK: - Initialization
    
    /// Create a new user profile with default values
    /// - Parameters:
    ///   - id: Unique identifier (defaults to a new UUID)
    ///   - name: User's name (defaults to "User")
    ///   - birthDate: User's birth date (defaults to 30 years ago)
    ///   - lifeExpectancy: Expected life span (defaults to 90 years)
    ///   - timerName: Custom timer name (defaults to "My Life Timer")
    ///   - requiresAuthentication: Whether authentication is required (defaults to false)
    ///   - usesReducedMotion: Whether to use reduced motion (defaults to false)
    init(
        id: UUID = UUID(),
        name: String = "User",
        birthDate: Date? = nil,
        lifeExpectancy: Int = 90,
        timerName: String = "My Life Timer",
        requiresAuthentication: Bool = false,
        usesReducedMotion: Bool = false
    ) {
        self.id = id
        self.name = name
        
        // Default to 30 years ago if no birth date provided
        if let birthDate = birthDate {
            self.birthDate = birthDate
        } else {
            let calendar = Calendar.current
            self.birthDate = calendar.date(byAdding: .year, value: -30, to: Date()) ?? Date()
        }
        
        self.lifeExpectancy = lifeExpectancy
        self.timerName = timerName
        self.requiresAuthentication = requiresAuthentication
        self.usesReducedMotion = usesReducedMotion
        self.lastUpdated = Date()
    }
    
    // MARK: - Factory Methods
    
    /// Create a sample user profile for previews and testing
    /// - Returns: A sample user profile
    static func sample() -> UserProfile {
        let calendar = Calendar.current
        let birthDate = calendar.date(byAdding: .year, value: -33, to: Date()) ?? Date()
        
        return UserProfile(
            name: "John Doe",
            birthDate: birthDate,
            lifeExpectancy: 90,
            timerName: "My Journey",
            requiresAuthentication: true,
            usesReducedMotion: false
        )
    }
} 