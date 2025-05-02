import SwiftUI

struct StatisticsView: View {
    var body: some View {
        MainContainer {
            VStack(spacing: 2.remToPt()) {
                // Header
                Text("STATISTICS")
                    .headingStyle()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 0.5.remToPt())
                
                // Stats content
                VStack(spacing: 1.5.remToPt()) {
                    // Life percentage stat
                    StatCard(
                        title: "LIFE COMPLETION",
                        value: "27%",
                        description: "of estimated life completed"
                    )
                    
                    // Days remaining stat
                    StatCard(
                        title: "DAYS REMAINING",
                        value: "23,962",
                        description: "based on life expectancy"
                    )
                    
                    // Milestone stat
                    StatCard(
                        title: "NEXT MILESTONE",
                        value: "30%",
                        description: "in 274 days"
                    )
                    
                    // Journal stats
                    StatCard(
                        title: "JOURNAL ENTRIES",
                        value: "42",
                        description: "last entry was 2 days ago"
                    )
                }
            }
            .frame(maxWidth: 800)
        }
    }
}

// MARK: - Helper Components

/// Card view for displaying a statistic
struct StatCard: View {
    let title: String
    let value: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1.remToPt()) {
            // Title
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(ColorTheme.textSecondary)
                .tracking(0.1.remToPt())
                .textCase(.uppercase)
            
            // Main value
            Text(value)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            // Description
            Text(description)
                .font(.system(size: 16))
                .foregroundColor(ColorTheme.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(1.5.remToPt())
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Preview

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
            .preferredColorScheme(.dark)
            .background(ColorTheme.backgroundPrimary)
    }
} 