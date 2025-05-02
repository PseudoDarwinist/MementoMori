import SwiftUI

/// Component for an individual carousel slide
struct CarouselSlide: View {
    // MARK: - Environment
    
    @EnvironmentObject private var contentProvider: ContentProvider
    
    // MARK: - Properties
    
    /// The content to display in this slide
    let content: InspirationContent
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image section
            imageSection
                .frame(height: 250)
            
            // Content section
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(content.title)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                
                // Text content
                Text(content.text)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.white.opacity(0.9))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
                
                // Attribution if available
                if let attribution = content.attribution {
                    Text("— \(attribution)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.top, 4)
                }
                
                // Type indicator (can be customized further)
                HStack {
                    Spacer()
                    
                    Text(content.contentType.rawValue.capitalized)
                        .font(.system(size: 12, weight: .medium))
                        .textCase(.uppercase)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                }
                .padding(.top, 8)
            }
            .padding(20)
        }
        .background(Color(white: 1.0, opacity: 0.03))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.03), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 15, x: 0, y: 5)
        .padding(.horizontal, 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(content.title): \(content.text)")
    }
    
    // MARK: - Components
    
    /// Image section of the slide
    private var imageSection: some View {
        ZStack {
            // Background color or pattern
            Color(white: 0.0, opacity: 0.1)
            
            // Image if available
            Group {
                if let _ = content.imageURL {
                    contentProvider.image(for: content)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    // Default image or pattern based on content type
                    Image(systemName: iconForContentType)
                        .font(.system(size: 40))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.03), lineWidth: 1)
                .mask(
                    // Only show the bottom edge of the stroke
                    Rectangle()
                        .frame(height: 250)
                )
        )
    }
    
    // MARK: - Helper Properties
    
    /// Default system icon based on content type
    private var iconForContentType: String {
        switch content.contentType {
        case .quote:
            return "quote.bubble"
        case .image:
            return "photo"
        case .gallery:
            return "photo.on.rectangle"
        case .reflection:
            return "person.thought.bubble"
        case .challenge:
            return "flame"
        }
    }
}

// MARK: - Preview

struct CarouselSlide_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(red: 0.01, green: 0.05, blue: 0.15)
                .ignoresSafeArea()
            
            CarouselSlide(content: InspirationContent.samples[0])
                .environmentObject(ContentProvider(
                    coreDataManager: CoreDataManager.shared,
                    userManager: UserManager.shared
                ))
                .padding()
        }
    }
} 