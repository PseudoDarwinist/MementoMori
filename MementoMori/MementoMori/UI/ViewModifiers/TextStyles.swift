import SwiftUI

/// Applies heading style to text
struct HeadingStyle: ViewModifier {
    var uppercase: Bool = true
    var letterSpacing: CGFloat = FontTheme.wideLetterSpacing
    
    func body(content: Content) -> some View {
        content
            .font(FontTheme.heading())
            .foregroundColor(ColorTheme.textPrimary)
            .tracking(letterSpacing)
            .textCase(uppercase ? .uppercase : nil)
    }
}

/// Applies secondary text style (70% white)
struct SecondaryTextStyle: ViewModifier {
    var uppercase: Bool = false
    var letterSpacing: CGFloat = FontTheme.normalLetterSpacing
    
    func body(content: Content) -> some View {
        content
            .font(FontTheme.body())
            .foregroundColor(ColorTheme.textSecondary)
            .tracking(letterSpacing)
            .textCase(uppercase ? .uppercase : nil)
    }
}

/// Applies small text style
struct SmallTextStyle: ViewModifier {
    var uppercase: Bool = false
    var letterSpacing: CGFloat = FontTheme.normalLetterSpacing
    var secondary: Bool = true
    
    func body(content: Content) -> some View {
        content
            .font(FontTheme.small())
            .foregroundColor(secondary ? ColorTheme.textSecondary : ColorTheme.textPrimary)
            .tracking(letterSpacing)
            .textCase(uppercase ? .uppercase : nil)
    }
}

/// Applies logo text style
struct LogoTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(FontTheme.logo())
            .foregroundColor(ColorTheme.textPrimary)
            .tracking(FontTheme.brandingLetterSpacing)
            .textCase(.uppercase)
    }
}

/// Applies 3D text effect for timer display
struct TimerTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: ColorTheme.shadowColor, radius: 2, x: 0, y: 2)
            .shadow(color: ColorTheme.shadowColor.opacity(0.4), radius: 1, x: 0, y: 1)
    }
}

extension View {
    /// Apply heading style to view
    /// - Parameters:
    ///   - uppercase: Whether text should be uppercase
    ///   - letterSpacing: Letter spacing in em units
    /// - Returns: Modified view
    func headingStyle(uppercase: Bool = true, letterSpacing: CGFloat = FontTheme.wideLetterSpacing) -> some View {
        self.modifier(HeadingStyle(uppercase: uppercase, letterSpacing: letterSpacing))
    }
    
    /// Apply secondary text style to view
    /// - Parameters:
    ///   - uppercase: Whether text should be uppercase
    ///   - letterSpacing: Letter spacing in em units
    /// - Returns: Modified view
    func secondaryTextStyle(uppercase: Bool = false, letterSpacing: CGFloat = FontTheme.normalLetterSpacing) -> some View {
        self.modifier(SecondaryTextStyle(uppercase: uppercase, letterSpacing: letterSpacing))
    }
    
    /// Apply small text style to view
    /// - Parameters:
    ///   - uppercase: Whether text should be uppercase
    ///   - letterSpacing: Letter spacing in em units
    ///   - secondary: Whether to use secondary (70% white) text color
    /// - Returns: Modified view
    func smallTextStyle(uppercase: Bool = false, letterSpacing: CGFloat = FontTheme.normalLetterSpacing, secondary: Bool = true) -> some View {
        self.modifier(SmallTextStyle(uppercase: uppercase, letterSpacing: letterSpacing, secondary: secondary))
    }
    
    /// Apply logo text style to view
    /// - Returns: Modified view
    func logoTextStyle() -> some View {
        self.modifier(LogoTextStyle())
    }
    
    /// Apply timer text style with 3D effect
    /// - Returns: Modified view
    func timerTextStyle() -> some View {
        self.modifier(TimerTextStyle())
    }
} 