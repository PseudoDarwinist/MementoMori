import Foundation

/// Model representing a philosophical quote
struct Quote: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the quote
    let id: UUID
    
    /// The quote text
    let text: String
    
    /// Who said or wrote the quote
    let attribution: String
    
    /// Category or theme of the quote (e.g., "Stoicism", "Buddhism", "Existentialism")
    let category: String?
    
    /// When the quote was last displayed to the user
    var lastDisplayed: Date?
    
    /// How many times the quote has been displayed
    var displayCount: Int
    
    // MARK: - Initialization
    
    init(id: UUID = UUID(), text: String, attribution: String, category: String? = nil, lastDisplayed: Date? = nil, displayCount: Int = 0) {
        self.id = id
        self.text = text
        self.attribution = attribution
        self.category = category
        self.lastDisplayed = lastDisplayed
        self.displayCount = displayCount
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Quote, rhs: Quote) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Extensions

extension Quote {
    /// Sample quotes for previews and initial data
    static let samples = [
        Quote(text: "Memento Mori - Remember that you will die, and live accordingly.", attribution: "Ancient Roman Philosophy", category: "Stoicism"),
        Quote(text: "We are all apprentices in a craft where no one becomes a master.", attribution: "Ernest Hemingway", category: "Existentialism"),
        Quote(text: "Time is the most valuable thing a man can spend.", attribution: "Theophrastus", category: "Ancient Greek"),
        Quote(text: "It is not death that a man should fear, but he should fear never beginning to live.", attribution: "Marcus Aurelius", category: "Stoicism"),
        Quote(text: "To fear death is nothing other than to think oneself wise when one is not.", attribution: "Socrates", category: "Ancient Greek"),
        Quote(text: "Death does not concern us, because as long as we exist, death is not here. And when it does come, we no longer exist.", attribution: "Epicurus", category: "Epicureanism"),
        Quote(text: "Let us prepare our minds as if we'd come to the very end of life. Let us postpone nothing. Let us balance life's books each day.", attribution: "Seneca", category: "Stoicism"),
        Quote(text: "You could leave life right now. Let that determine what you do and say and think.", attribution: "Marcus Aurelius", category: "Stoicism"),
        Quote(text: "The fear of death follows from the fear of life. A man who lives fully is prepared to die at any time.", attribution: "Mark Twain", category: "American Literature"),
        Quote(text: "Life is a dream for the wise, a game for the fool, a comedy for the rich, a tragedy for the poor.", attribution: "Sholom Aleichem", category: "Jewish Wisdom")
    ]
    
    /// Returns a random quote from the sample list
    static func random() -> Quote {
        samples.randomElement()!
    }
} 