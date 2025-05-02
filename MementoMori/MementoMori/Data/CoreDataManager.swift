import Foundation
import CoreData
import os.log

/// Central manager for Core Data operations
class CoreDataManager {
    // MARK: - Singleton
    
    /// Shared instance for the app
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    
    /// Logger for Core Data operations
    private let logger = Logger(subsystem: "com.mementomori", category: "CoreDataManager")
    
    /// The Core Data container
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MementoMori")
        container.loadPersistentStores { [weak self] storeDescription, error in
            if let error = error as NSError? {
                self?.logger.error("Failed to load Core Data: \(error.localizedDescription)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            // Enable automatic merging of changes from parent contexts
            container.viewContext.automaticallyMergesChangesFromParent = true
            
            // Configure merge policy
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            
            self?.logger.info("Core Data stack initialized successfully")
        }
        return container
    }()
    
    /// Main view context for UI operations
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Initialization
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    // MARK: - Context Management
    
    /// Create a background context for operations that should not block the UI
    func createBackgroundContext() -> NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    /// Perform work on a background context
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        let context = createBackgroundContext()
        context.perform {
            block(context)
        }
    }
    
    // MARK: - Saving
    
    /// Save changes in the specified context
    /// - Parameter context: The managed object context to save
    /// - Returns: Whether the save was successful
    @discardableResult
    func save(context: NSManagedObjectContext) -> Bool {
        do {
            if context.hasChanges {
                try context.save()
                return true
            }
            return true
        } catch {
            logger.error("Core Data save error: \(error.localizedDescription)")
            return false
        }
    }
    
    /// Save the main view context
    /// - Returns: Whether the save was successful
    @discardableResult
    func saveViewContext() -> Bool {
        return save(context: viewContext)
    }
    
    // MARK: - Backup and Migration
    
    /// Create a backup of the Core Data store
    func createBackup() {
        // Implementation will be added in a future story
        logger.info("Backup requested (not yet implemented)")
    }
    
    /// Perform cleanup operations
    func performMaintenance() {
        // Implementation for database maintenance will be added in a future story
        logger.info("Maintenance performed")
    }
}

// MARK: - Error Handling

extension CoreDataManager {
    /// Represents possible Core Data errors
    enum CoreDataError: Error {
        case saveError(String)
        case fetchError(String)
        case deleteError(String)
        case invalidModelType
        case objectNotFound
        case invalidData
    }
} 