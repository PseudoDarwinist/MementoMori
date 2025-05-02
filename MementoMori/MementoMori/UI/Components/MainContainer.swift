import SwiftUI

/// Main container for content that enforces consistent layout and styling
struct MainContainer<Content: View>: View {
    // MARK: - Properties
    
    /// The content to display inside the container
    let content: Content
    
    /// Whether to apply responsive padding for mobile devices
    var responsivePadding: Bool = true
    
    /// Whether to apply centered alignment to content
    var centered: Bool = true
    
    /// Whether to manage z-index layering
    var manageZIndex: Bool = true
    
    /// Whether to handle overflow content with scrolling
    var handleOverflow: Bool = true
    
    // Computed properties for responsive design
    private var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
    
    private var horizontalPadding: CGFloat {
        isPhone ? 0.8.remToPt() : 1.5.remToPt()
    }
    
    // MARK: - Initialization
    
    /// Create a MainContainer with the specified content
    /// - Parameter content: The content to display inside the container
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            if handleOverflow {
                ScrollView {
                    containerContent
                }
                .scrollIndicators(.hidden)
            } else {
                containerContent
            }
        }
        .frame(maxWidth: 1200)
        .zIndex(manageZIndex ? 0 : 1)
        .transition(.opacity.animation(.easeInOut(duration: 0.3)))
    }
    
    // MARK: - Private Views
    
    /// The main container content with proper padding and layout
    private var containerContent: some View {
        content
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
            .padding(.horizontal, horizontalPadding)
            .padding(.top, 0.8.remToPt())
            .padding(.bottom, 2.5.remToPt()) // Bottom padding for the tab bar
    }
}

// MARK: - View Extension

extension View {
    /// Wrap the view in a MainContainer
    /// - Parameters:
    ///   - responsivePadding: Whether to apply responsive padding for mobile devices
    ///   - centered: Whether to apply centered alignment to content
    ///   - manageZIndex: Whether to manage z-index layering
    ///   - handleOverflow: Whether to handle overflow content with scrolling
    /// - Returns: The wrapped view
    func inMainContainer(
        responsivePadding: Bool = true,
        centered: Bool = true,
        manageZIndex: Bool = true,
        handleOverflow: Bool = true
    ) -> some View {
        MainContainer {
            self
        }
        .responsivePadding(responsivePadding)
        .centered(centered)
        .manageZIndex(manageZIndex)
        .handleOverflow(handleOverflow)
    }
}

// MARK: - MainContainer Modifiers

extension MainContainer {
    /// Set whether to apply responsive padding for mobile devices
    /// - Parameter value: The value to set
    /// - Returns: The modified container
    func responsivePadding(_ value: Bool) -> MainContainer {
        var container = self
        container.responsivePadding = value
        return container
    }
    
    /// Set whether to apply centered alignment to content
    /// - Parameter value: The value to set
    /// - Returns: The modified container
    func centered(_ value: Bool) -> MainContainer {
        var container = self
        container.centered = value
        return container
    }
    
    /// Set whether to manage z-index layering
    /// - Parameter value: The value to set
    /// - Returns: The modified container
    func manageZIndex(_ value: Bool) -> MainContainer {
        var container = self
        container.manageZIndex = value
        return container
    }
    
    /// Set whether to handle overflow content with scrolling
    /// - Parameter value: The value to set
    /// - Returns: The modified container
    func handleOverflow(_ value: Bool) -> MainContainer {
        var container = self
        container.handleOverflow = value
        return container
    }
}

// MARK: - Preview

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        
        VStack(spacing: 2.remToPt()) {
            Text("MAIN CONTAINER")
                .headingStyle()
            
            Text("This is a sample content inside a main container component.")
                .font(FontTheme.body())
                .multilineTextAlignment(.center)
            
            Spacer().frame(height: 2.remToPt())
            
            VStack(spacing: 1.remToPt()) {
                ForEach(0..<5) { index in
                    Text("Content section \(index + 1)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ColorTheme.cardBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 0.75.remToPt()))
                        .overlay(
                            RoundedRectangle(cornerRadius: 0.75.remToPt())
                                .stroke(ColorTheme.borderColor, lineWidth: 1)
                        )
                }
            }
        }
        .inMainContainer()
    }
    .withBackgroundEffects()
} 