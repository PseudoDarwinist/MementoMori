import SwiftUI

/// Component for displaying philosophical quotes
struct QuoteView: View {
    // MARK: - Properties
    
    /// Quote text to display
    let text: String
    
    /// Attribution or source of the quote
    let attribution: String
    
    /// Whether to animate the appearance
    var animate: Bool = true
    
    /// Animation state
    @State private var opacity: Double = 0
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0.6.remToPt()) {
            // Quote text
            Text("\"\(text)\"")
                .font(.system(size: 0.95.remToPt(), weight: .light, design: .serif))
                .italic()
                .foregroundColor(ColorTheme.textPrimary)
                .multilineTextAlignment(.center)
                .lineSpacing(0.4.remToPt()) // Reduced line height
                .fixedSize(horizontal: false, vertical: true)
            
            // Attribution
            Text("— \(attribution)")
                .font(.system(size: 0.7.remToPt(), weight: .regular))
                .foregroundColor(ColorTheme.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.top, 0.3.remToPt())
        }
        .padding([.top, .bottom], 0.7.remToPt())
        .padding([.leading, .trailing], 1.5.remToPt())
        .frame(maxWidth: 650) // Max width constraint
        .opacity(opacity)
        .onAppear {
            if animate {
                withAnimation(.easeIn(duration: 0.8)) {
                    opacity = 1.0
                }
            } else {
                opacity = 1.0
            }
        }
    }
}

// MARK: - Optional extension for external creation without animation

extension QuoteView {
    /// Creates a random quote
    static func random() -> QuoteView {
        let quotes = [
            ("Memento Mori - Remember that you will die, and live accordingly.", "Ancient Roman Philosophy"),
            ("We are all apprentices in a craft where no one becomes a master.", "Ernest Hemingway"),
            ("Time is the most valuable thing a man can spend.", "Theophrastus"),
            ("It is not death that a man should fear, but he should fear never beginning to live.", "Marcus Aurelius"),
            ("To fear death is nothing other than to think oneself wise when one is not.", "Socrates")
        ]
        
        let randomQuote = quotes.randomElement()!
        return QuoteView(text: randomQuote.0, attribution: randomQuote.1)
    }
}

// MARK: - Preview

struct QuoteView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorTheme.backgroundPrimary.ignoresSafeArea()
            
            QuoteView(
                text: "It is not death that a man should fear, but he should fear never beginning to live.",
                attribution: "Marcus Aurelius"
            )
        }
        .preferredColorScheme(.dark)
    }
} 