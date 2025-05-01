import SwiftUI

struct JournalView: View {
    var body: some View {
        VStack(spacing: 2.remToPt()) {
            // Header
            Text("JOURNAL")
                .headingStyle()
            
            // Journal entries list placeholder
            VStack(spacing: 1.remToPt()) {
                ForEach(1...5, id: \.self) { index in
                    JournalEntryRow(
                        date: "2022-0\(index)-\(10+index)",
                        title: "Journal Entry #\(index)",
                        preview: "This is a preview of the journal entry content. Tap to view the full entry."
                    )
                }
            }
            
            Spacer()
            
            // New entry button
            Button(action: {}) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("New Entry")
                }
                .padding()
                .background(ColorTheme.accentPrimary)
                .foregroundColor(.white)
                .cornerRadius(25)
            }
            .padding(.bottom, 1.remToPt())
        }
        .padding(2.remToPt())
    }
}

// MARK: - Helper Components

/// Placeholder for a journal entry row
struct JournalEntryRow: View {
    let date: String
    let title: String
    let preview: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0.5.remToPt()) {
            // Date
            Text(date)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(ColorTheme.accentPrimary)
            
            // Title
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(ColorTheme.textPrimary)
            
            // Preview
            Text(preview)
                .font(.system(size: 14))
                .foregroundColor(ColorTheme.textSecondary)
                .lineLimit(2)
        }
        .padding(1.remToPt())
        .background(ColorTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(ColorTheme.borderColor, lineWidth: 1)
        )
    }
}

// MARK: - Preview

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
            .preferredColorScheme(.dark)
            .background(ColorTheme.backgroundPrimary)
    }
} 