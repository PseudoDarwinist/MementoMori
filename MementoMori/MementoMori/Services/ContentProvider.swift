import Foundation
import Combine
import SwiftUI
import os.log

/// Service for managing and providing inspirational content
class ContentProvider: ObservableObject {
    // MARK: - Properties
    
    /// Published array of inspirational content items
    @Published private(set) var inspirationItems: [InspirationContent] = []
    
    /// Currently displayed content
    @Published private(set) var currentContent: InspirationContent?
    
    /// Logger for content operations
    private let logger = Logger(subsystem: "com.mementomori", category: "ContentProvider")
    
    /// Timer for content rotation
    private var rotationTimer: Timer?
    
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
        loadContent()
        
        // Select initial content
        selectRandomContent()
        
        // Subscribe to user changes to reload content
        // We'll monitor userProfile changes instead of currentProfile
        NotificationCenter.default.publisher(for: .userProfileDidChange)
            .sink { [weak self] _ in
                self?.loadContent()
                self?.selectRandomContent()
            }
            .store(in: &cancellables)
        
        // Start rotation timer
        startContentRotation()
    }
    
    deinit {
        stopContentRotation()
    }
    
    // MARK: - Content Management
    
    /// Load all inspiration content
    private func loadContent() {
        // This is a placeholder implementation using sample data
        // In a future story, this will be implemented with Core Data
        inspirationItems = InspirationContent.samples
        logger.info("Loaded \(self.inspirationItems.count) inspiration items")
    }
    
    /// Select a random content item for display
    /// - Returns: The selected content item
    @discardableResult
    func selectRandomContent() -> InspirationContent? {
        guard !inspirationItems.isEmpty else {
            logger.warning("Cannot select random content: No content available")
            currentContent = nil
            return nil
        }
        
        // Filter out recently displayed content if possible
        let filteredItems = inspirationItems.filter { item in
            guard let lastDisplayed = item.lastDisplayed else { return true }
            // Filter out content displayed in the last 24 hours if we have enough items
            let hoursAgo = Calendar.current.dateComponents([.hour], from: lastDisplayed, to: Date()).hour ?? 0
            return inspirationItems.count <= 5 || hoursAgo >= 24
        }
        
        // Select random item from filtered list or full list if filtered is empty
        let itemsToSelectFrom = filteredItems.isEmpty ? inspirationItems : filteredItems
        var selectedItem = itemsToSelectFrom.randomElement()!
        
        // Update display count and last displayed
        selectedItem.displayCount += 1
        selectedItem.lastDisplayed = Date()
        
        // Update current content
        currentContent = selectedItem
        logger.info("Selected random content: \(selectedItem.id)")
        
        return selectedItem
    }
    
    /// Select a specific content item by ID
    /// - Parameter id: The ID of the content to select
    /// - Returns: The selected content item if found
    @discardableResult
    func selectContent(id: UUID) -> InspirationContent? {
        guard let item = inspirationItems.first(where: { $0.id == id }) else {
            logger.error("Failed to select content: Content not found with ID \(id)")
            return nil
        }
        
        var updatedItem = item
        updatedItem.displayCount += 1
        updatedItem.lastDisplayed = Date()
        
        currentContent = updatedItem
        logger.info("Selected content: \(updatedItem.id)")
        
        return updatedItem
    }
    
    /// Get content items by category
    /// - Parameter category: The category to filter by
    /// - Returns: Array of matching content items
    func getContentByCategory(_ category: String) -> [InspirationContent] {
        return inspirationItems.filter { $0.category == category }
    }
    
    /// Get content items by type
    /// - Parameter type: The content type to filter by
    /// - Returns: Array of matching content items
    func getContentByType(_ type: InspirationContent.ContentType) -> [InspirationContent] {
        return inspirationItems.filter { $0.contentType == type }
    }
    
    // MARK: - Content Rotation
    
    /// Start the automatic content rotation timer
    private func startContentRotation() {
        stopContentRotation() // Stop any existing timer
        
        // Create a new timer that rotates content every 24 hours
        rotationTimer = Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { [weak self] _ in
            self?.selectRandomContent()
        }
        
        logger.info("Started content rotation timer")
    }
    
    /// Stop the automatic content rotation timer
    private func stopContentRotation() {
        rotationTimer?.invalidate()
        rotationTimer = nil
    }
    
    /// Image for the given content item
    /// - Parameter item: The content item
    /// - Returns: UIImage to display
    func image(for item: InspirationContent) -> Image {
        // This is a placeholder implementation
        // In a future story, this will be implemented with proper image loading
        
        guard let imageName = item.imageURL else {
            return Image(systemName: "photo")
        }
        
        // Try to load from asset catalog
        return Image(imageName, bundle: nil)
    }
} 