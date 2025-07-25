//
//  ScreenBackground.swift
//  secant-testnet
//
//  Created by Francisco Gindre on 10/18/21.
//

import Design
import SwiftUI

// MARK: - ScreenGradientBackground
public struct ScreenGradientBackground: View {
    // MARK: SwiftUI Properties
    @Environment(\.colorScheme) private var colorScheme

    // MARK: Properties
    private let stops: [Gradient.Stop]

    // MARK: Lifecycle
    public init(stops: [Gradient.Stop]) {
        self.stops = stops
    }

    // MARK: Content Properties

    // MARK: Content
    public var body: some View {
        LinearGradient(
            stops: stops,
            startPoint: .topLeading,
            endPoint: .bottom
        )
    }
}

// MARK: - ScreenGradientBackgroundModifier
struct ScreenGradientBackgroundModifier: ViewModifier {
    // MARK: Properties
    let stops: [Gradient.Stop]

    // MARK: Content Methods

    // MARK: Content
    func body(content: Content) -> some View {
        ZStack {
            ScreenGradientBackground(stops: stops)
                .edgesIgnoringSafeArea(.all)

            content
        }
    }
}

public extension View {
    func applyScreenBackground() -> some View {
        modifier(
            ScreenGradientBackgroundModifier(
                stops: [
                    Gradient.Stop(color: Colors.ZPallete.blue500.color, location: 0.0),
                    Gradient.Stop(color: .black, location: 0.8),
                    Gradient.Stop(color: .black, location: 1.0),
                ]
            )
        )
    }
}
