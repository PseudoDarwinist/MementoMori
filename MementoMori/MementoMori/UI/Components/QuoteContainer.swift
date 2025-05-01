import SwiftUI

/// Container component for displaying and rotating quotes
struct QuoteContainer: View {
    // MARK: - Properties
    
    /// Quote service for managing quotes
    @ObservedObject private var quoteService = QuoteService.shared
    
    /// State to track if we are currently animating a quote change
    @State private var isChangingQuote = false
    
    /// The current displayed quote
    @State private var displayedQuote: Quote
    
    /// State to control rotation animation
    @State private var opacity: Double = 1.0
    
    // MARK: - Initialization
    
    init() {
        // Set the initial quote from the service
        _displayedQuote = State(initialValue: QuoteService.shared.currentQuote)
        
        // Initialize the quote database if needed
        DispatchQueue.main.async {
            QuoteService.shared.initializeFullQuoteDatabase()
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            QuoteView(
                text: displayedQuote.text,
                attribution: displayedQuote.attribution,
                animate: !isChangingQuote
            )
            .opacity(opacity)
            .contentShape(Rectangle()) // Make the whole area tappable
            .onTapGesture {
                rotateQuote()
            }
        }
        .onAppear {
            // Set up a timer to change the quote every 24 hours
            Timer.scheduledTimer(withTimeInterval: 24 * 60 * 60, repeats: true) { _ in
                rotateQuote()
            }
        }
    }
    
    // MARK: - Methods
    
    /// Rotate to a new quote with animation
    private func rotateQuote() {
        guard !isChangingQuote else { return }
        
        isChangingQuote = true
        
        // Fade out current quote
        withAnimation(.easeOut(duration: 0.5)) {
            opacity = 0.0
        }
        
        // After fade out, change the quote and fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            // Get a new quote
            let newQuote = quoteService.getNewQuote()
            displayedQuote = newQuote
            
            // Fade in the new quote
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
            
            // Reset changing state after animation completes
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isChangingQuote = false
            }
        }
    }
}

// MARK: - Preview

struct QuoteContainer_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ColorTheme.backgroundPrimary.ignoresSafeArea()
            
            QuoteContainer()
        }
        .preferredColorScheme(.dark)
    }
} 