import SwiftUI

/// Screen for displaying inspiration content
struct InspirationView: View {
    // MARK: - Environment
    
    @EnvironmentObject private var contentProvider: ContentProvider
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 32) {
            // Title
            Text("Inspiration")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
            
            // Inspiration carousel
            CarouselContainer()
                .padding(.bottom, 20)
            
            // Additional content
            inspirationLibrary
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
        .background(Color(red: 0.01, green: 0.05, blue: 0.15))
    }
    
    // MARK: - Components
    
    /// Section showing inspiration by category
    private var inspirationLibrary: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Section header
            HStack(spacing: 16) {
                Text("Inspiration Library")
                    .font(.system(size: 14, weight: .medium))
                    .textCase(.uppercase)
                    .tracking(2)
                    .foregroundColor(.white.opacity(0.7))
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.white.opacity(0.3))
            }
            .padding(.horizontal, 20)
            
            // Category tiles
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    // Add category buttons
                    categoryTile(title: "Quotes", icon: "quote.bubble", count: countForType(.quote))
                    categoryTile(title: "Images", icon: "photo", count: countForType(.image))
                    categoryTile(title: "Reflections", icon: "person.thought.bubble", count: countForType(.reflection))
                    categoryTile(title: "Challenges", icon: "flame", count: countForType(.challenge))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
            }
        }
    }
    
    /// Create a category tile button
    /// - Parameters:
    ///   - title: Category title
    ///   - icon: SF Symbol name
    ///   - count: Number of items in category
    /// - Returns: Category button view
    private func categoryTile(title: String, icon: String, count: Int) -> some View {
        Button(action: {
            // Action would navigate to category view
            print("Navigate to \(title)")
        }) {
            VStack(spacing: 12) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Color.white.opacity(0.05))
                    .cornerRadius(16)
                
                // Title and count
                VStack(spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text("\(count) items")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .frame(width: 120)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.02))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.05), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Helper Methods
    
    /// Count items for a specific content type
    /// - Parameter type: The content type
    /// - Returns: Number of items of that type
    private func countForType(_ type: InspirationContent.ContentType) -> Int {
        contentProvider.inspirationItems.filter { $0.contentType == type }.count
    }
}

// MARK: - Preview

struct InspirationView_Previews: PreviewProvider {
    static var previews: some View {
        InspirationView()
            .environmentObject(ContentProvider(
                coreDataManager: CoreDataManager.shared,
                userManager: UserManager.shared
            ))
            .preferredColorScheme(.dark)
    }
} 