import Foundation
import SwiftUI

/// Service for managing philosophical quotes
class QuoteService: ObservableObject {
    // MARK: - Properties
    
    /// Shared instance of the quote service (singleton)
    static let shared = QuoteService()
    
    /// Currently selected quote for display
    @Published var currentQuote: Quote
    
    /// All available quotes
    private var allQuotes: [Quote]
    
    /// Recently displayed quotes to avoid repetition
    private var recentQuotes: [UUID] = []
    
    /// Maximum number of quotes to keep in the recently displayed list
    private let maxRecentQuotes = 10
    
    /// The user defaults key for storing quotes
    private let quotesKey = "com.mementomori.quotes"
    
    /// The user defaults key for storing recent quotes
    private let recentQuotesKey = "com.mementomori.recentQuotes"
    
    /// The user defaults key for storing the current quote
    private let currentQuoteKey = "com.mementomori.currentQuote"
    
    // MARK: - Initialization
    
    private init() {
        // Initialize with default values first, then load from storage
        self.allQuotes = Quote.samples
        self.currentQuote = Quote.samples[0]
        
        // Now we can safely call methods that use self
        if let storedQuotes = loadQuotesFromStorage() {
            self.allQuotes = storedQuotes
        } else {
            saveQuotesToStorage()
        }
        
        // Load recent quotes if available
        if let storedRecentQuotes = UserDefaults.standard.array(forKey: recentQuotesKey) as? [String] {
            self.recentQuotes = storedRecentQuotes.compactMap { UUID(uuidString: $0) }
        }
        
        // Try to load the current quote, or select a random one
        if let storedCurrentQuote = loadCurrentQuoteFromStorage() {
            self.currentQuote = storedCurrentQuote
        } else {
            self.currentQuote = selectRandomQuote()
        }
    }
    
    // MARK: - Public Methods
    
    /// Returns a new random quote different from the current one
    func getNewQuote() -> Quote {
        let newQuote = selectRandomQuote()
        currentQuote = newQuote
        saveCurrentQuoteToStorage()
        return newQuote
    }
    
    /// Add a new quote to the database
    func addQuote(_ quote: Quote) {
        allQuotes.append(quote)
        saveQuotesToStorage()
    }
    
    /// Add multiple quotes to the database
    func addQuotes(_ quotes: [Quote]) {
        allQuotes.append(contentsOf: quotes)
        saveQuotesToStorage()
    }
    
    /// Filter quotes by category
    func getQuotes(byCategory category: String) -> [Quote] {
        return allQuotes.filter { $0.category == category }
    }
    
    /// Get all quotes sorted by attribution
    func getAllQuotes() -> [Quote] {
        return allQuotes.sorted { $0.attribution < $1.attribution }
    }
    
    // MARK: - Private Methods
    
    /// Select a random quote that hasn't been shown recently
    private func selectRandomQuote() -> Quote {
        // Filter out recently shown quotes if possible
        let availableQuotes = allQuotes.filter { quote in
            !recentQuotes.contains(quote.id)
        }
        
        // Use available quotes if we have enough, otherwise use all quotes
        let quotePool = availableQuotes.count > 3 ? availableQuotes : allQuotes
        
        // Get a random quote from the pool
        guard let randomQuote = quotePool.randomElement() else {
            // Fallback if the array is somehow empty
            return Quote.samples[0]
        }
        
        // Update recently used quotes
        updateRecentQuotes(randomQuote.id)
        
        // Update display count for the selected quote
        if let index = allQuotes.firstIndex(where: { $0.id == randomQuote.id }) {
            allQuotes[index].displayCount += 1
            allQuotes[index].lastDisplayed = Date()
            saveQuotesToStorage()
        }
        
        return randomQuote
    }
    
    /// Update the list of recently used quotes
    private func updateRecentQuotes(_ quoteId: UUID) {
        // Add to recent quotes
        recentQuotes.append(quoteId)
        
        // Trim list if needed
        if recentQuotes.count > maxRecentQuotes {
            recentQuotes = Array(recentQuotes.suffix(maxRecentQuotes))
        }
        
        // Save recent quotes
        let recentQuoteStrings = recentQuotes.map { $0.uuidString }
        UserDefaults.standard.set(recentQuoteStrings, forKey: recentQuotesKey)
    }
    
    // MARK: - Storage Methods
    
    /// Save all quotes to UserDefaults
    private func saveQuotesToStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(allQuotes)
            UserDefaults.standard.set(data, forKey: quotesKey)
        } catch {
            print("Error saving quotes: \(error.localizedDescription)")
        }
    }
    
    /// Load quotes from UserDefaults
    private func loadQuotesFromStorage() -> [Quote]? {
        guard let data = UserDefaults.standard.data(forKey: quotesKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([Quote].self, from: data)
        } catch {
            print("Error loading quotes: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Save current quote to UserDefaults
    private func saveCurrentQuoteToStorage() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(currentQuote)
            UserDefaults.standard.set(data, forKey: currentQuoteKey)
        } catch {
            print("Error saving current quote: \(error.localizedDescription)")
        }
    }
    
    /// Load current quote from UserDefaults
    private func loadCurrentQuoteFromStorage() -> Quote? {
        guard let data = UserDefaults.standard.data(forKey: currentQuoteKey) else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Quote.self, from: data)
        } catch {
            print("Error loading current quote: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Quote Database Initialization
    
    /// Initialize the quote database with a comprehensive set of quotes
    func initializeFullQuoteDatabase() {
        // Only initialize if we only have sample quotes (10 quotes)
        if allQuotes.count <= 10 {
            addQuotes(fullQuoteDatabase)
        }
    }
    
    /// Full database of philosophical quotes about mortality and time
    private var fullQuoteDatabase: [Quote] {
        [
            // Stoicism
            Quote(text: "You act like mortals in all that you fear, and like immortals in all that you desire.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "It's not because things are difficult that we don't dare; it's because we don't dare that things are difficult.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "Begin at once to live, and count each separate day as a separate life.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "We suffer more often in imagination than in reality.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "The whole future lies in uncertainty: live immediately.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "Life is very short and anxious for those who forget the past, neglect the present, and fear the future.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "He who fears death will never do anything worth of a living man.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "No man can have a peaceful life who thinks too much about lengthening it.", attribution: "Seneca", category: "Stoicism"),
            Quote(text: "What is to come is not ours, not yet.", attribution: "Seneca", category: "Stoicism"),
            
            Quote(text: "You have power over your mind - not outside events. Realize this, and you will find strength.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "Very little is needed to make a happy life; it is all within yourself, in your way of thinking.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "Never let the future disturb you. You will meet it, if you have to, with the same weapons of reason which today arm you against the present.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "The happiness of your life depends upon the quality of your thoughts.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "Think of yourself as dead. You have lived your life. Now, take what's left and live it properly.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "What we do now echoes in eternity.", attribution: "Marcus Aurelius", category: "Stoicism"),
            Quote(text: "Accept the things to which fate binds you, and love the people with whom fate brings you together, but do so with all your heart.", attribution: "Marcus Aurelius", category: "Stoicism"),
            
            Quote(text: "Make the best use of what is in your power, and take the rest as it happens.", attribution: "Epictetus", category: "Stoicism"),
            Quote(text: "It's not what happens to you, but how you react to it that matters.", attribution: "Epictetus", category: "Stoicism"),
            Quote(text: "No man is free who is not master of himself.", attribution: "Epictetus", category: "Stoicism"),
            Quote(text: "First say to yourself what you would be; and then do what you have to do.", attribution: "Epictetus", category: "Stoicism"),
            Quote(text: "If you want to improve, be content to be thought foolish and stupid.", attribution: "Epictetus", category: "Stoicism"),
            
            // Ancient Greek & Roman
            Quote(text: "Beware the barrenness of a busy life.", attribution: "Socrates", category: "Ancient Greek"),
            Quote(text: "The unexamined life is not worth living.", attribution: "Socrates", category: "Ancient Greek"),
            Quote(text: "Death may be the greatest of all human blessings.", attribution: "Socrates", category: "Ancient Greek"),
            Quote(text: "There is only one good, knowledge, and one evil, ignorance.", attribution: "Socrates", category: "Ancient Greek"),
            
            Quote(text: "Everything flows and nothing abides. Everything gives way and nothing stays fixed.", attribution: "Heraclitus", category: "Ancient Greek"),
            Quote(text: "No man ever steps in the same river twice, for it's not the same river and he's not the same man.", attribution: "Heraclitus", category: "Ancient Greek"),
            Quote(text: "The only constant in life is change.", attribution: "Heraclitus", category: "Ancient Greek"),
            
            Quote(text: "Be kind, for everyone you meet is fighting a hard battle.", attribution: "Plato", category: "Ancient Greek"),
            Quote(text: "The greatest wealth is to live content with little.", attribution: "Plato", category: "Ancient Greek"),
            Quote(text: "We can easily forgive a child who is afraid of the dark; the real tragedy of life is when men are afraid of the light.", attribution: "Plato", category: "Ancient Greek"),
            
            Quote(text: "Pleasure in the job puts perfection in the work.", attribution: "Aristotle", category: "Ancient Greek"),
            Quote(text: "It is during our darkest moments that we must focus to see the light.", attribution: "Aristotle", category: "Ancient Greek"),
            Quote(text: "Excellence is never an accident. It is always the result of high intention, sincere effort, and intelligent execution.", attribution: "Aristotle", category: "Ancient Greek"),
            
            // Buddhist Philosophy
            Quote(text: "The trouble is, you think you have time.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "What you are is what you have been. What you'll be is what you do now.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "Do not dwell in the past, do not dream of the future, concentrate the mind on the present moment.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "Three things cannot be long hidden: the sun, the moon, and the truth.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "Peace comes from within. Do not seek it without.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "Each morning we are born again. What we do today is what matters most.", attribution: "Buddha", category: "Buddhism"),
            Quote(text: "The way is not in the sky. The way is in the heart.", attribution: "Buddha", category: "Buddhism"),
            
            // Existentialism
            Quote(text: "Man is condemned to be free; because once thrown into the world, he is responsible for everything he does.", attribution: "Jean-Paul Sartre", category: "Existentialism"),
            Quote(text: "One always dies too soon—or too late. And yet one's whole life is complete at that moment, with a line drawn neatly under it, ready for the summing up. You are your life, and nothing else.", attribution: "Jean-Paul Sartre", category: "Existentialism"),
            Quote(text: "Life is nothing until it is lived; but it is yours to make sense of, and the value of it is nothing else but the sense that you choose.", attribution: "Jean-Paul Sartre", category: "Existentialism"),
            
            Quote(text: "The irrationality of a thing is no argument against its existence, rather a condition of it.", attribution: "Friedrich Nietzsche", category: "Existentialism"),
            Quote(text: "He who has a why to live can bear almost any how.", attribution: "Friedrich Nietzsche", category: "Existentialism"),
            Quote(text: "To live is to suffer, to survive is to find some meaning in the suffering.", attribution: "Friedrich Nietzsche", category: "Existentialism"),
            Quote(text: "That which does not kill us makes us stronger.", attribution: "Friedrich Nietzsche", category: "Existentialism"),
            
            Quote(text: "Anxiety is the dizziness of freedom.", attribution: "Søren Kierkegaard", category: "Existentialism"),
            Quote(text: "Life can only be understood backwards; but it must be lived forwards.", attribution: "Søren Kierkegaard", category: "Existentialism"),
            Quote(text: "The function of prayer is not to influence God, but rather to change the nature of the one who prays.", attribution: "Søren Kierkegaard", category: "Existentialism"),
            Quote(text: "Life is not a problem to be solved, but a reality to be experienced.", attribution: "Søren Kierkegaard", category: "Existentialism"),
            
            Quote(text: "One must imagine Sisyphus happy.", attribution: "Albert Camus", category: "Existentialism"),
            Quote(text: "In the midst of winter, I found there was, within me, an invincible summer.", attribution: "Albert Camus", category: "Existentialism"),
            Quote(text: "Should I kill myself, or have a cup of coffee?", attribution: "Albert Camus", category: "Existentialism"),
            Quote(text: "Nobody realizes that some people expend tremendous energy merely to be normal.", attribution: "Albert Camus", category: "Existentialism"),
            
            // Modern Quotes
            Quote(text: "The fear of death follows from the fear of life. A man who lives fully is prepared to die at any time.", attribution: "Mark Twain", category: "Modern"),
            Quote(text: "The goal isn't to live forever, it's to create something that will.", attribution: "Chuck Palahniuk", category: "Modern"),
            Quote(text: "It is not the length of life, but the depth of life.", attribution: "Ralph Waldo Emerson", category: "Modern"),
            Quote(text: "If you live each day as if it was your last, someday you'll most certainly be right.", attribution: "Steve Jobs", category: "Modern"),
            Quote(text: "Twenty years from now you will be more disappointed by the things that you didn't do than by the ones you did do.", attribution: "Mark Twain", category: "Modern"),
            Quote(text: "The proper function of man is to live, not to exist. I shall not waste my days in trying to prolong them. I shall use my time.", attribution: "Jack London", category: "Modern"),
            Quote(text: "Life is what happens when you're busy making other plans.", attribution: "John Lennon", category: "Modern"),
            Quote(text: "To live is the rarest thing in the world. Most people exist, that is all.", attribution: "Oscar Wilde", category: "Modern"),
            Quote(text: "Life is really simple, but we insist on making it complicated.", attribution: "Confucius", category: "Modern"),
            Quote(text: "In three words I can sum up everything I've learned about life: it goes on.", attribution: "Robert Frost", category: "Modern"),
            Quote(text: "Yesterday is history, tomorrow is a mystery, but today is a gift. That's why we call it the present.", attribution: "Eleanor Roosevelt", category: "Modern")
        ]
    }
} 