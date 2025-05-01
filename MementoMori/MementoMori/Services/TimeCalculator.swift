import Foundation

/// Service for calculating time-related data for the life timer
final class TimeCalculator {
    // MARK: - Singleton
    
    static let shared = TimeCalculator()
    
    // MARK: - Cache
    
    /// Cache of calculated time data to improve performance
    private var calculationCache: [String: TimeData] = [:]
    
    /// Cache expiration time in seconds
    private let cacheExpirationTime: TimeInterval = 3600 // 1 hour
    
    /// Last calculation timestamp
    private var lastCalculationTime: Date?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Calculate time data based on birth date and life expectancy
    /// - Parameters:
    ///   - birthDate: User's birth date
    ///   - lifeExpectancy: Expected life span in years
    ///   - forceFresh: Force fresh calculation, ignoring cache
    /// - Returns: TimeData object with calculated values
    func calculateTimeData(
        birthDate: Date,
        lifeExpectancy: Int,
        forceFresh: Bool = false
    ) -> TimeData {
        // Create cache key
        let cacheKey = "\(birthDate.timeIntervalSince1970)_\(lifeExpectancy)"
        
        // Check if we have a valid cached result
        if !forceFresh,
           let cachedData = calculationCache[cacheKey],
           let lastCalculation = lastCalculationTime,
           Date().timeIntervalSince(lastCalculation) < cacheExpirationTime {
            return cachedData
        }
        
        // Validate inputs
        guard isValidBirthDate(birthDate) else {
            return TimeData.invalid(reason: "Invalid birth date")
        }
        
        guard isValidLifeExpectancy(lifeExpectancy) else {
            return TimeData.invalid(reason: "Invalid life expectancy")
        }
        
        // Calculate end date
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .year, value: lifeExpectancy, to: birthDate) else {
            return TimeData.invalid(reason: "Failed to calculate end date")
        }
        
        let now = Date()
        
        // Calculate time components
        let totalDaysInLife = birthDate.daysTill(endDate)
        let daysLived = birthDate.daysTill(now)
        let daysRemaining = max(0, endDate.daysTill(now) * -1)
        
        // Calculate percentage
        let lifeCompletionPercentage = Date.lifeCompletionPercentage(
            birthDate: birthDate, 
            lifeExpectancy: lifeExpectancy
        )
        
        // Calculate detailed time components
        let (years, months, days) = calculateYearsMonthsDays(daysRemaining: daysRemaining)
        let (hours, minutes, seconds) = calculateHoursMinutesSeconds()
        
        // Create TimeData object
        let timeData = TimeData(
            birthDate: birthDate,
            lifeExpectancy: lifeExpectancy,
            totalDaysInLife: totalDaysInLife,
            daysLived: daysLived,
            daysRemaining: daysRemaining,
            yearsRemaining: years,
            monthsRemaining: months,
            daysRemainingInMonth: days,
            hoursRemaining: hours,
            minutesRemaining: minutes,
            secondsRemaining: seconds,
            completionPercentage: lifeCompletionPercentage,
            isValid: true,
            validationMessage: nil,
            calculationTimestamp: now
        )
        
        // Cache result
        calculationCache[cacheKey] = timeData
        lastCalculationTime = now
        
        return timeData
    }
    
    /// Update seconds in existing time data
    /// - Parameter timeData: Previous time data to update
    /// - Returns: Updated time data with current seconds
    func updateSeconds(timeData: TimeData) -> TimeData {
        // For performance, we just update the seconds component
        // This is called frequently for real-time updates
        let (hours, minutes, seconds) = calculateHoursMinutesSeconds()
        
        var updatedData = timeData
        updatedData.hoursRemaining = hours
        updatedData.minutesRemaining = minutes
        updatedData.secondsRemaining = seconds
        
        return updatedData
    }
    
    /// Clear calculation cache
    func clearCache() {
        calculationCache.removeAll()
        lastCalculationTime = nil
    }
    
    // MARK: - Private Helper Methods
    
    /// Validate birth date is in the past and not too extreme
    /// - Parameter date: Birth date to validate
    /// - Returns: Whether the date is valid
    private func isValidBirthDate(_ date: Date) -> Bool {
        let now = Date()
        
        // Birth date must be in the past
        guard date < now else {
            return false
        }
        
        // Check for extreme dates (more than 150 years in the past)
        let calendar = Calendar.current
        guard let minDate = calendar.date(byAdding: .year, value: -150, to: now),
              date > minDate else {
            return false
        }
        
        return true
    }
    
    /// Validate life expectancy is within reasonable range
    /// - Parameter years: Life expectancy in years
    /// - Returns: Whether the value is valid
    private func isValidLifeExpectancy(_ years: Int) -> Bool {
        // Valid range: 30-150 years
        return years >= 30 && years <= 150
    }
    
    /// Calculate years, months, and days from total days remaining
    /// - Parameter daysRemaining: Total days remaining
    /// - Returns: Tuple of (years, months, days)
    private func calculateYearsMonthsDays(daysRemaining: Int) -> (Int, Int, Int) {
        let calendar = Calendar.current
        let now = Date()
        
        // Calculate future date that is daysRemaining in the future
        guard let futureDate = calendar.date(byAdding: .day, value: daysRemaining, to: now) else {
            return (0, 0, 0)
        }
        
        // Get components between now and future date
        let components = calendar.dateComponents([.year, .month, .day], from: now, to: futureDate)
        
        return (
            components.year ?? 0,
            components.month ?? 0,
            components.day ?? 0
        )
    }
    
    /// Calculate hours, minutes, seconds for the current time
    /// - Returns: Tuple of (hours, minutes, seconds)
    private func calculateHoursMinutesSeconds() -> (Int, Int, Int) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.hour, .minute, .second], from: now)
        
        // Calculate time until next day (remaining in current day)
        let secondsInDay = 24 * 60 * 60
        let secondsPassed = (components.hour ?? 0) * 3600 + (components.minute ?? 0) * 60 + (components.second ?? 0)
        let secondsLeft = secondsInDay - secondsPassed
        
        let hoursLeft = secondsLeft / 3600
        let minutesLeft = (secondsLeft % 3600) / 60
        let secondsLeftInMinute = secondsLeft % 60
        
        return (hoursLeft, minutesLeft, secondsLeftInMinute)
    }
} 