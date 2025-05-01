import SwiftUI

/// Font theme for the Memento Mori app
/// Contains all font definitions used throughout the app
enum FontTheme {
    // MARK: - Font Names
    static let timerFontName = "Futura-CondensedExtraBold" // Fallback to System Bold if not available
    static let primaryFontName = "SystemFont"
    
    // MARK: - Font Sizes
    static let logoSize: CGFloat = 1.2
    static let headingSize: CGFloat = 0.9
    static let bodySize: CGFloat = 1.1
    static let smallSize: CGFloat = 0.8
    static let smallerSize: CGFloat = 0.7
    
    // MARK: - Font Weights
    static let regular = Font.Weight.regular
    static let medium = Font.Weight.medium
    static let semibold = Font.Weight.semibold
    static let bold = Font.Weight.bold
    static let heavy = Font.Weight.heavy
    
    // MARK: - Line Heights
    static let defaultLineHeight: CGFloat = 1.2
    static let relaxedLineHeight: CGFloat = 1.4
    static let spaciousLineHeight: CGFloat = 1.6
    
    // MARK: - Letter Spacing
    static let tightLetterSpacing: CGFloat = -0.02
    static let normalLetterSpacing: CGFloat = 0
    static let wideLetterSpacing: CGFloat = 0.05
    static let extraWideLetterSpacing: CGFloat = 0.15
    static let brandingLetterSpacing: CGFloat = 0.2
    
    // MARK: - Font Styles (SwiftUI)
    static func logo() -> Font {
        Font.custom(primaryFontName, size: logoSize.remToPt())
            .weight(bold)
    }
    
    static func heading() -> Font {
        Font.custom(primaryFontName, size: headingSize.remToPt())
            .weight(semibold)
    }
    
    static func body() -> Font {
        Font.custom(primaryFontName, size: bodySize.remToPt())
            .weight(regular)
    }
    
    static func small() -> Font {
        Font.custom(primaryFontName, size: smallSize.remToPt())
            .weight(regular)
    }
    
    static func smaller() -> Font {
        Font.custom(primaryFontName, size: smallerSize.remToPt())
            .weight(regular)
    }
    
    static func timer() -> Font {
        // First try to use Futura-CondensedExtraBold, fall back to system heavy
        let fontSize = 3.5.remToPt()
        
        // Try to use the custom font
        if UIFont(name: timerFontName, size: fontSize) != nil {
            return Font.custom(timerFontName, size: fontSize)
        } else {
            // Fall back to system font with heavy weight
            return Font.system(size: fontSize, weight: .heavy)
        }
    }
} 