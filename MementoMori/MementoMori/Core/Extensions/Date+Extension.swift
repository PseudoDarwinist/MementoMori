import Foundation

extension Date {
    /// Calculate the number of days from this date to another date
    /// - Parameter date: The target date to calculate days until
    /// - Returns: Number of days between dates (negative if target date is in the past)
    func daysTill(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: date)
        return components.day ?? 0
    }
    
    /// Calculate the number of days from birth to estimated end of life
    /// - Parameters:
    ///   - birthDate: The birth date
    ///   - lifeExpectancy: Life expectancy in years
    /// - Returns: Total number of days in expected lifetime
    static func totalDaysInLife(from birthDate: Date, lifeExpectancy: Int) -> Int {
        let calendar = Calendar.current
        guard let endDate = calendar.date(byAdding: .year, value: lifeExpectancy, to: birthDate) else {
            return 0
        }
        
        return birthDate.daysTill(endDate)
    }
    
    /// Calculate percentage of life completed
    /// - Parameters:
    ///   - birthDate: The birth date
    ///   - lifeExpectancy: Life expectancy in years
    /// - Returns: Percentage of life completed (0-100)
    static func lifeCompletionPercentage(birthDate: Date, lifeExpectancy: Int) -> Double {
        let now = Date()
        let totalDays = Double(totalDaysInLife(from: birthDate, lifeExpectancy: lifeExpectancy))
        let daysLived = Double(birthDate.daysTill(now))
        
        guard totalDays > 0 else { return 0 }
        let percentage = (daysLived / totalDays) * 100
        return max(0, min(100, percentage)) // Clamp between 0-100
    }
    
    /// Format date in standard app display format
    /// - Returns: Formatted date string
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
} 