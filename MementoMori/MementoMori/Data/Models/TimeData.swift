import Foundation

/// Model representing calculated time data for the life timer
struct TimeData: Codable, Equatable {
    // MARK: - Properties
    
    /// User's birth date
    var birthDate: Date
    
    /// Expected life span in years
    var lifeExpectancy: Int
    
    /// Total days in expected lifetime
    var totalDaysInLife: Int
    
    /// Number of days lived so far
    var daysLived: Int
    
    /// Total days remaining in life
    var daysRemaining: Int
    
    /// Years component of remaining time
    var yearsRemaining: Int
    
    /// Months component of remaining time
    var monthsRemaining: Int
    
    /// Days component of remaining time (within current month)
    var daysRemainingInMonth: Int
    
    /// Hours component of remaining time (within current day)
    var hoursRemaining: Int
    
    /// Minutes component of remaining time (within current hour)
    var minutesRemaining: Int
    
    /// Seconds component of remaining time (within current minute)
    var secondsRemaining: Int
    
    /// Percentage of life completed (0-100)
    var completionPercentage: Double
    
    /// Whether the calculation is valid
    var isValid: Bool
    
    /// Validation message if calculation is invalid
    var validationMessage: String?
    
    /// Timestamp when calculation was performed
    var calculationTimestamp: Date
    
    // MARK: - Computed Properties
    
    /// Formatted percentage string (e.g., "27%")
    var formattedPercentage: String {
        return "\(Int(completionPercentage))%"
    }
    
    /// Formatted years remaining string with leading zeros
    var formattedYearsRemaining: String {
        return String(format: "%02d", yearsRemaining)
    }
    
    /// Formatted months remaining string with leading zeros
    var formattedMonthsRemaining: String {
        return String(format: "%02d", monthsRemaining)
    }
    
    /// Formatted days remaining string with leading zeros
    var formattedDaysRemaining: String {
        return String(format: "%02d", daysRemainingInMonth)
    }
    
    /// Formatted hours remaining string with leading zeros
    var formattedHoursRemaining: String {
        return String(format: "%02d", hoursRemaining)
    }
    
    /// Formatted minutes remaining string with leading zeros
    var formattedMinutesRemaining: String {
        return String(format: "%02d", minutesRemaining)
    }
    
    /// Formatted seconds remaining string with leading zeros
    var formattedSecondsRemaining: String {
        return String(format: "%02d", secondsRemaining)
    }
    
    // MARK: - Factory Methods
    
    /// Create an invalid TimeData instance with an error message
    /// - Parameter reason: The reason why the data is invalid
    /// - Returns: An invalid TimeData instance
    static func invalid(reason: String) -> TimeData {
        return TimeData(
            birthDate: Date(),
            lifeExpectancy: 0,
            totalDaysInLife: 0,
            daysLived: 0,
            daysRemaining: 0,
            yearsRemaining: 0,
            monthsRemaining: 0,
            daysRemainingInMonth: 0,
            hoursRemaining: 0,
            minutesRemaining: 0,
            secondsRemaining: 0,
            completionPercentage: 0,
            isValid: false,
            validationMessage: reason,
            calculationTimestamp: Date()
        )
    }
    
    /// Create a sample TimeData for previews and testing
    /// - Returns: A sample TimeData instance
    static func sample() -> TimeData {
        // Sample data represents someone born 33 years ago with 90 year life expectancy
        let calendar = Calendar.current
        let now = Date()
        let birthDate = calendar.date(byAdding: .year, value: -33, to: now) ?? now
        
        return TimeData(
            birthDate: birthDate,
            lifeExpectancy: 90,
            totalDaysInLife: 32872,
            daysLived: 12053,
            daysRemaining: 20819,
            yearsRemaining: 57,
            monthsRemaining: 0,
            daysRemainingInMonth: 0,
            hoursRemaining: 23,
            minutesRemaining: 59,
            secondsRemaining: 59,
            completionPercentage: 36.67,
            isValid: true,
            validationMessage: nil,
            calculationTimestamp: now
        )
    }
} 