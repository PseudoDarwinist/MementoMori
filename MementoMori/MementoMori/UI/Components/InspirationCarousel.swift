import SwiftUI

/// Component for displaying daily inspirations in a carousel
struct InspirationCarousel: View {
    // MARK: - Properties
    
    /// Currently selected slide index
    @State private var currentIndex = 0
    
    /// Sample data for carousel
    let items: [InspirationItem] = [
        InspirationItem(id: 1, title: "The Man in the Arena", content: "It is not the critic who counts; not the man who points out how the strong man stumbles...", image: "inspiration1"),
        InspirationItem(id: 2, title: "Memento Mori", content: "Remember that you will die. Let this knowledge transform how you live.", image: "inspiration2"),
        InspirationItem(id: 3, title: "Present Moment", content: "The present moment is the only moment available to us, and it is the door to all moments.", image: "inspiration3"),
        InspirationItem(id: 4, title: "Inner Citadel", content: "The happiness of your life depends upon the quality of your thoughts.", image: "inspiration4")
    ]
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.8.remToPt()) {
            // Section header
            HStack {
                Text("DAILY INSPIRATIONS")
                    .font(.system(size: 14, weight: .semibold))
                    .tracking(0.15.remToPt())
                    .foregroundColor(ColorTheme.textSecondary)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(ColorTheme.textSecondary.opacity(0.3))
            }
            .padding(.horizontal, 0.8.remToPt())
            
            // Carousel content
            ZStack(alignment: .bottom) {
                // Image content with full height
                TabView(selection: $currentIndex) {
                    ForEach(0..<items.count, id: \.self) { index in
                        CarouselItemView(item: items[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(minHeight: 250, maxHeight: .infinity) // Use more vertical space
                
                // Navigation arrows and indicators
                HStack {
                    // Left arrow
                    Button(action: {
                        withAnimation {
                            currentIndex = (currentIndex - 1 + items.count) % items.count
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                            .frame(width: 36, height: 36)
                            .background(ColorTheme.textPrimary.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    // Indicators
                    HStack(spacing: 6) {
                        ForEach(0..<items.count, id: \.self) { index in
                            Circle()
                                .fill(currentIndex == index ? ColorTheme.accentPrimary : ColorTheme.textSecondary.opacity(0.3))
                                .frame(width: 6, height: 6)
                        }
                    }
                    
                    Spacer()
                    
                    // Right arrow
                    Button(action: {
                        withAnimation {
                            currentIndex = (currentIndex + 1) % items.count
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(ColorTheme.textPrimary)
                            .frame(width: 36, height: 36)
                            .background(ColorTheme.textPrimary.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 0.8.remToPt())
                .padding(.bottom, 0.5.remToPt())
            }
        }
    }
}

// MARK: - Carousel Item View

/// Individual slide for the carousel
struct CarouselItemView: View {
    let item: InspirationItem
    
    var body: some View {
        // Simple image display without caption overlay
        ZStack {
            // Background image or placeholder
            Rectangle()
                .fill(ColorTheme.cardBackground)
                .overlay(
                    // Placeholder for image - use actual image in production
                    Text(item.image)
                        .foregroundColor(ColorTheme.textSecondary.opacity(0.5))
                )
        }
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
        .padding(.horizontal, 0.8.remToPt())
    }
}

// MARK: - Inspiration Item Model

/// Model for carousel items
struct InspirationItem: Identifiable {
    let id: Int
    let title: String
    let content: String
    let image: String
}

// MARK: - Preview

#Preview {
    ZStack {
        ColorTheme.backgroundPrimary.ignoresSafeArea()
        
        VStack {
            Spacer()
            InspirationCarousel()
            // Add a placeholder to simulate tab bar height
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .frame(height: 60)
        }
    }
    .preferredColorScheme(.dark)
} 