import SwiftUI

/// Component for carousel page indicators
struct CarouselIndicators: View {
    // MARK: - Properties
    
    /// Total number of pages
    let pageCount: Int
    
    /// Binding to current page index
    @Binding var currentPage: Int
    
    /// Width of each indicator
    var indicatorWidth: CGFloat = 32
    
    /// Height of each indicator
    var indicatorHeight: CGFloat = 3
    
    /// Spacing between indicators
    var spacing: CGFloat = 8
    
    /// Color for active indicator
    var activeColor = Color.white
    
    /// Color for inactive indicators
    var inactiveColor = Color.white.opacity(0.3)
    
    // MARK: - Body
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<pageCount, id: \.self) { index in
                // Indicator bar
                Capsule()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(width: indicatorWidth, height: indicatorHeight)
                    .onTapGesture {
                        // Navigate to tapped page
                        withAnimation {
                            currentPage = index
                        }
                        
                        // Provide haptic feedback
                        #if os(iOS)
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        #endif
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Page \(index + 1) of \(pageCount)")
                    .accessibilityAddTraits(index == currentPage ? [.isSelected] : [])
                    .accessibilityHint("Double tap to go to page \(index + 1)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(Color.black.opacity(0.3))
                .blur(radius: 5)
        )
    }
}

// MARK: - Preview

struct CarouselIndicators_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.01, green: 0.05, blue: 0.15)
                .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Default
                CarouselIndicators(
                    pageCount: 5,
                    currentPage: .constant(2)
                )
                
                // Customized
                CarouselIndicators(
                    pageCount: 3,
                    currentPage: .constant(0),
                    indicatorWidth: 40,
                    indicatorHeight: 5,
                    spacing: 12,
                    activeColor: Color.blue,
                    inactiveColor: Color.gray.opacity(0.5)
                )
            }
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
} 