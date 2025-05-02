import Foundation

/// Model representing a journal entry
struct JournalEntry: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the entry
    let id: UUID
    
    /// The title of the journal entry
    var title: String
    
    /// The content/body of the journal entry
    var content: String
    
    /// When the entry was created
    let createdAt: Date
    
    /// When the entry was last modified
    var modifiedAt: Date
    
    /// Tags associated with the entry (for future functionality)
    var tags: [String]
    
    /// Whether the entry is a favorite
    var isFavorite: Bool
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        title: String = "",
        content: String = "",
        createdAt: Date = Date(),
        modifiedAt: Date = Date(),
        tags: [String] = [],
        isFavorite: Bool = false
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.tags = tags
        self.isFavorite = isFavorite
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: JournalEntry, rhs: JournalEntry) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Extensions

extension JournalEntry {
    /// Returns a preview summary of the content (first few words)
    var preview: String {
        let words = content.split(separator: " ")
        let previewWords = words.prefix(15)
        let preview = previewWords.joined(separator: " ")
        
        return preview + (words.count > 15 ? "..." : "")
    }
    
    /// Returns a formatted date string for the creation date
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
    
    /// Sample journal entries for previews and testing
    static let samples = [
        JournalEntry(
            title: "Reflecting on mortality",
            content: "Today I spent some time thinking about how finite our lives truly are. It made me appreciate the little moments more - the morning coffee, conversation with a friend, and the sunset I witnessed on my way home. There's something powerful about acknowledging our limited time that makes everything more vibrant.",
            createdAt: Date().addingTimeInterval(-86400 * 2),
            tags: ["reflection", "gratitude"],
            isFavorite: true
        ),
        JournalEntry(
            title: "New beginnings",
            content: "Started using this app today to become more mindful of my time. It's both terrifying and liberating to see my life quantified this way. I want to use this awareness to make better choices going forward.",
            createdAt: Date().addingTimeInterval(-86400 * 5),
            tags: ["goals", "mindfulness"]
        ),
        JournalEntry(
            title: "Daily thoughts",
            content: "Just a quick entry today. Reminded myself to call mom more often. Life is too short for missed connections.",
            createdAt: Date().addingTimeInterval(-86400)
        )
    ]
} 