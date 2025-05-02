import Foundation
import Combine
import CoreData
import os.log

/// Service for managing journal entries
class JournalManager: ObservableObject {
    // MARK: - Properties
    
    /// Published array of journal entries
    @Published private(set) var entries: [JournalEntry] = []
    
    /// Logger for journal operations
    private let logger = Logger(subsystem: "com.mementomori", category: "JournalManager")
    
    /// CoreDataManager instance
    private let coreDataManager: CoreDataManager
    
    /// User manager for the current user
    private let userManager: UserManager
    
    /// Cancellable store for subscriptions
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    /// Initialize with the dependencies
    /// - Parameters:
    ///   - coreDataManager: CoreDataManager instance
    ///   - userManager: UserManager instance
    init(coreDataManager: CoreDataManager = .shared, userManager: UserManager = .shared) {
        self.coreDataManager = coreDataManager
        self.userManager = userManager
        
        // Load initial data
        loadEntries()
        
        // Subscribe to user changes to reload entries
        // We'll monitor userProfile changes instead of currentProfile
        NotificationCenter.default.publisher(for: .userProfileDidChange)
            .sink { [weak self] _ in
                self?.loadEntries()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - CRUD Operations
    
    /// Load all journal entries for the current user
    func loadEntries() {
        // This is a placeholder implementation using sample data
        // In a future story, this will be implemented with Core Data
        entries = JournalEntry.samples
        logger.info("Loaded \(self.entries.count) journal entries")
    }
    
    /// Save a new or updated journal entry
    /// - Parameter entry: The journal entry to save
    /// - Returns: Whether the save was successful
    @discardableResult
    func saveEntry(_ entry: JournalEntry) -> Bool {
        // This is a placeholder implementation
        // In a future story, this will be implemented with Core Data
        
        // For now, we'll just update the in-memory entries
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            logger.info("Updated journal entry: \(entry.id)")
        } else {
            entries.append(entry)
            logger.info("Added new journal entry: \(entry.id)")
        }
        
        // Sort entries by created date (newest first)
        entries.sort { $0.createdAt > $1.createdAt }
        
        return true
    }
    
    /// Create a new journal entry
    /// - Parameters:
    ///   - title: The entry title
    ///   - content: The entry content
    /// - Returns: The created journal entry
    func createEntry(title: String, content: String) -> JournalEntry {
        let newEntry = JournalEntry(
            title: title,
            content: content,
            createdAt: Date(),
            modifiedAt: Date()
        )
        
        saveEntry(newEntry)
        return newEntry
    }
    
    /// Delete a journal entry
    /// - Parameter id: The ID of the entry to delete
    /// - Returns: Whether the deletion was successful
    @discardableResult
    func deleteEntry(id: UUID) -> Bool {
        guard let index = entries.firstIndex(where: { $0.id == id }) else {
            logger.error("Failed to delete journal entry: Entry not found with ID \(id)")
            return false
        }
        
        entries.remove(at: index)
        logger.info("Deleted journal entry: \(id)")
        return true
    }
    
    /// Get a journal entry by ID
    /// - Parameter id: The ID of the entry to retrieve
    /// - Returns: The journal entry if found
    func getEntry(id: UUID) -> JournalEntry? {
        return entries.first { $0.id == id }
    }
    
    /// Update an existing journal entry
    /// - Parameters:
    ///   - id: The ID of the entry to update
    ///   - title: The new title
    ///   - content: The new content
    ///   - isFavorite: Whether the entry is a favorite
    /// - Returns: The updated entry if successful
    func updateEntry(id: UUID, title: String, content: String, isFavorite: Bool? = nil) -> JournalEntry? {
        guard var entry = getEntry(id: id) else {
            logger.error("Failed to update journal entry: Entry not found with ID \(id)")
            return nil
        }
        
        entry.title = title
        entry.content = content
        entry.modifiedAt = Date()
        
        if let isFavorite = isFavorite {
            entry.isFavorite = isFavorite
        }
        
        saveEntry(entry)
        return entry
    }
    
    /// Toggle the favorite status of an entry
    /// - Parameter id: The ID of the entry
    /// - Returns: The updated entry if successful
    func toggleFavorite(id: UUID) -> JournalEntry? {
        guard var entry = getEntry(id: id) else {
            logger.error("Failed to toggle favorite: Entry not found with ID \(id)")
            return nil
        }
        
        entry.isFavorite.toggle()
        saveEntry(entry)
        return entry
    }
    
    // MARK: - Filtering and Sorting
    
    /// Get all entries sorted by a specified attribute
    /// - Parameter sortBy: The attribute to sort by
    /// - Returns: Sorted array of journal entries
    func getAllEntries(sortBy: SortAttribute = .date) -> [JournalEntry] {
        switch sortBy {
        case .date:
            return entries.sorted { $0.createdAt > $1.createdAt }
        case .title:
            return entries.sorted { $0.title < $1.title }
        case .favorite:
            return entries.sorted { $0.isFavorite && !$1.isFavorite }
        }
    }
    
    /// Search entries by query text
    /// - Parameter query: The search query
    /// - Returns: Array of matching entries
    func searchEntries(query: String) -> [JournalEntry] {
        guard !query.isEmpty else { return entries }
        
        let lowercasedQuery = query.lowercased()
        return entries.filter {
            $0.title.lowercased().contains(lowercasedQuery) ||
            $0.content.lowercased().contains(lowercasedQuery)
        }
    }
    
    /// Sort attribute options
    enum SortAttribute {
        case date
        case title
        case favorite
    }
} 