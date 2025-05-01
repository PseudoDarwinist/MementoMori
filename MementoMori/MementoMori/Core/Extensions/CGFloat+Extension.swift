import UIKit

extension CGFloat {
    /// Convert rem value to points
    /// Base is 16 points = 1 rem
    /// - Returns: The value in points
    func remToPt() -> CGFloat {
        // Standard base: 1 rem = 16 points
        return self * 16
    }
    
    /// Convert points to rem value
    /// Base is 16 points = 1 rem
    /// - Returns: The value in rem
    func ptToRem() -> CGFloat {
        // Standard base: 1 rem = 16 points
        return self / 16
    }
}

// Extension for Double to support the same rem conversion methods
extension Double {
    /// Convert rem value to points
    /// Base is 16 points = 1 rem
    /// - Returns: The value in points as CGFloat
    func remToPt() -> CGFloat {
        // Standard base: 1 rem = 16 points
        return CGFloat(self) * 16
    }
    
    /// Convert points to rem value
    /// Base is 16 points = 1 rem
    /// - Returns: The value in rem as CGFloat
    func ptToRem() -> CGFloat {
        // Standard base: 1 rem = 16 points
        return CGFloat(self) / 16
    }
} 