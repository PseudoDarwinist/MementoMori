import Foundation

/// Model representing a user goal
struct Goal: Identifiable, Codable, Hashable {
    // MARK: - Properties
    
    /// Unique identifier for the goal
    let id: UUID
    
    /// Title of the goal
    var title: String
    
    /// Detailed description of the goal
    var description: String
    
    /// Category or life area for the goal
    var category: Category
    
    /// Target date for goal completion
    var targetDate: Date?
    
    /// Current progress percentage (0-100)
    var progressPercentage: Double
    
    /// When the goal was created
    let createdAt: Date
    
    /// When the goal was last updated
    var updatedAt: Date
    
    /// Whether the goal has been completed
    var isCompleted: Bool
    
    /// Notes associated with this goal
    var notes: [Note]
    
    // MARK: - Nested Types
    
    /// Categories for goals
    enum Category: String, Codable, CaseIterable {
        case health = "Health"
        case career = "Career"
        case relationships = "Relationships"
        case personal = "Personal Growth"
        case financial = "Financial"
        case spiritual = "Spiritual"
        case experiences = "Experiences"
        case learning = "Learning"
        case creative = "Creative"
        case other = "Other"
        
        var icon: String {
            switch self {
            case .health: return "heart.fill"
            case .career: return "briefcase.fill"
            case .relationships: return "person.2.fill"
            case .personal: return "person.fill"
            case .financial: return "dollarsign.circle.fill"
            case .spiritual: return "sparkles"
            case .experiences: return "map.fill"
            case .learning: return "book.fill"
            case .creative: return "paintbrush.fill"
            case .other: return "star.fill"
            }
        }
        
        var color: String {
            switch self {
            case .health: return "health-red"
            case .career: return "career-blue"
            case .relationships: return "relationships-pink"
            case .personal: return "personal-purple"
            case .financial: return "financial-green"
            case .spiritual: return "spiritual-teal"
            case .experiences: return "experiences-orange"
            case .learning: return "learning-yellow"
            case .creative: return "creative-indigo"
            case .other: return "other-gray"
            }
        }
    }
    
    /// Note associated with a goal
    struct Note: Identifiable, Codable, Hashable {
        let id: UUID
        var text: String
        let createdAt: Date
        
        init(id: UUID = UUID(), text: String, createdAt: Date = Date()) {
            self.id = id
            self.text = text
            self.createdAt = createdAt
        }
    }
    
    // MARK: - Initialization
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        category: Category,
        targetDate: Date? = nil,
        progressPercentage: Double = 0.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        isCompleted: Bool = false,
        notes: [Note] = []
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.targetDate = targetDate
        self.progressPercentage = progressPercentage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isCompleted = isCompleted
        self.notes = notes
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Goal, rhs: Goal) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Extensions

extension Goal {
    /// Sample goals for previews and testing
    static let samples = [
        Goal(
            title: "Run a marathon",
            description: "Train for and complete a full marathon in under 4 hours",
            category: .health,
            targetDate: Calendar.current.date(byAdding: .month, value: 6, to: Date())!,
            progressPercentage: 35.0,
            notes: [
                Note(text: "Started training program today. 3 miles completed."),
                Note(text: "Signed up for the Chicago Marathon")
            ]
        ),
        Goal(
            title: "Learn Spanish",
            description: "Become conversationally fluent in Spanish",
            category: .learning,
            targetDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
            progressPercentage: 20.0,
            notes: [
                Note(text: "Completed first 10 Duolingo lessons")
            ]
        ),
        Goal(
            title: "Write a novel",
            description: "Complete the first draft of my novel about mortality and time",
            category: .creative,
            targetDate: Calendar.current.date(byAdding: .month, value: 9, to: Date())!,
            progressPercentage: 15.0
        ),
        Goal(
            title: "Backpack through Europe",
            description: "Visit at least 5 countries in Europe",
            category: .experiences,
            targetDate: Calendar.current.date(byAdding: .year, value: 2, to: Date())!,
            progressPercentage: 5.0,
            notes: [
                Note(text: "Started saving $200/month for the trip"),
                Note(text: "Researched best times to visit different regions")
            ]
        )
    ]
} 