import Foundation
import SwiftUI

/// Model representing an inspirational content item for the carousel
struct InspirationContent: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the content
    let id: UUID
    
    /// Title of the inspirational content
    var title: String
    
    /// The descriptive text or quote
    var text: String
    
    /// Attribution or source (optional)
    var attribution: String?
    
    /// Type of content
    var contentType: ContentType
    
    /// URL for the image or resource (local or remote)
    var imageURL: String?
    
    /// Category/theme of the content
    var category: String?
    
    /// Date when content was created
    let createdAt: Date
    
    /// Date when content was last displayed
    var lastDisplayed: Date?
    
    /// Number of times this content has been displayed
    var displayCount: Int
    
    // MARK: - Nested Types
    
    /// Types of inspirational content
    enum ContentType: String, Codable, CaseIterable {
        case quote
        case image
        case gallery
        case reflection
        case challenge
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        title: String,
        text: String,
        attribution: String? = nil,
        contentType: ContentType,
        imageURL: String? = nil,
        category: String? = nil,
        createdAt: Date = Date(),
        lastDisplayed: Date? = nil,
        displayCount: Int = 0
    ) {
        self.id = id
        self.title = title
        self.text = text
        self.attribution = attribution
        self.contentType = contentType
        self.imageURL = imageURL
        self.category = category
        self.createdAt = createdAt
        self.lastDisplayed = lastDisplayed
        self.displayCount = displayCount
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: InspirationContent, rhs: InspirationContent) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Extensions

extension InspirationContent {
    /// Default image to use if no image URL is provided or loading fails
    static var defaultImageName: String {
        "inspiration-placeholder"
    }
    
    /// Sample inspirational content for previews and testing
    static let samples = [
        InspirationContent(
            title: "Embrace Impermanence",
            text: "The flower that blooms in adversity is the most rare and beautiful of all.",
            attribution: "Mulan",
            contentType: .quote,
            imageURL: "inspiration-flower",
            category: "Mindfulness"
        ),
        InspirationContent(
            title: "Ocean Reflections",
            text: "We all come from the sea, but we are not all of the sea. Those of us who are, we children of the tides, must return to it again and again.",
            attribution: "Chasing Mavericks",
            contentType: .image,
            imageURL: "inspiration-ocean",
            category: "Nature"
        ),
        InspirationContent(
            title: "Daily Challenge",
            text: "Today, spend 10 minutes in silence, reflecting on what truly matters to you. What would you focus on if you only had one year left?",
            contentType: .challenge,
            category: "Self-improvement"
        ),
        InspirationContent(
            title: "Mountain Vista",
            text: "The mountains are calling and I must go.",
            attribution: "John Muir",
            contentType: .gallery,
            imageURL: "inspiration-mountains",
            category: "Nature"
        ),
        InspirationContent(
            title: "Time Reflection",
            text: "Time is the coin of your life. It is the only coin you have, and only you can determine how it will be spent.",
            attribution: "Carl Sandburg",
            contentType: .reflection,
            category: "Time"
        )
    ]
} 