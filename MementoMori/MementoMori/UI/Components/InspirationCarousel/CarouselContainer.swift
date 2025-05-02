import SwiftUI

/// Container component for the inspiration carousel
struct CarouselContainer: View {
    // MARK: - Environment
    
    @EnvironmentObject private var contentProvider: ContentProvider
    
    // MARK: - Properties
    
    /// Title for the carousel section
    var sectionTitle: String = "Daily Inspirations"
    
    /// Maximum width for the carousel
    var maxWidth: CGFloat = 850
    
    // MARK: - State
    
    /// Current page index
    @State private var currentPage = 0
    
    // MARK: - Computed Properties
    
    /// The number of pages in the carousel
    private var pageCount: Int {
        contentProvider.inspirationItems.count
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Header with section title and decorative line
            HStack(spacing: 16) {
                Text(sectionTitle)
                    .font(.system(size: 14, weight: .medium))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.7))
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.3))
            }
            
            if pageCount > 0 {
                // Carousel content
                ZStack(alignment: .bottom) {
                    // Slides
                    TabView(selection: $currentPage) {
                        ForEach(0..<pageCount, id: \.self) { index in
                            CarouselSlide(content: contentProvider.inspirationItems[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 400)
                    .animation(.easeInOut, value: currentPage)
                    
                    // Custom indicators
                    CarouselIndicators(
                        pageCount: pageCount,
                        currentPage: $currentPage
                    )
                    .padding(.bottom, 16)
                }
                
                // Navigation arrows
                HStack {
                    Spacer()
                    
                    // Previous button
                    CarouselNavigationButton(
                        systemName: "chevron.left",
                        action: previousPage
                    )
                    
                    Spacer()
                        .frame(width: 24)
                    
                    // Next button
                    CarouselNavigationButton(
                        systemName: "chevron.right",
                        action: nextPage
                    )
                    
                    Spacer()
                }
                .padding(.top, 8)
            } else {
                // Empty state
                VStack {
                    Text("No inspirations available")
                        .foregroundColor(.white.opacity(0.7))
                    
                    Button("Refresh") {
                        contentProvider.selectRandomContent()
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(8)
                }
                .frame(height: 300)
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: maxWidth)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Inspiration carousel")
    }
    
    // MARK: - Methods
    
    /// Navigate to the next page
    private func nextPage() {
        withAnimation {
            currentPage = (currentPage + 1) % pageCount
        }
    }
    
    /// Navigate to the previous page
    private func previousPage() {
        withAnimation {
            currentPage = (currentPage - 1 + pageCount) % pageCount
        }
    }
}

// MARK: - Preview

struct CarouselContainer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.01, green: 0.05, blue: 0.15)
                .ignoresSafeArea()
            
            CarouselContainer()
                .environmentObject(ContentProvider(
                    coreDataManager: CoreDataManager.shared,
                    userManager: UserManager.shared
                ))
        }
    }
} 