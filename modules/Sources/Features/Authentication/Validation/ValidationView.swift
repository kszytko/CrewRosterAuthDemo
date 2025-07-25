//
//  WelcomeView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-15.
//
import Foundation
import SwiftUI
import UIComponents

// MARK: - VerifyEmailView
struct ValidationView: View {
    // MARK: SwiftUI Properties
    @State var finished: Bool = false

    // MARK: Content Properties

    // MARK: Content
    var body: some View {
        content
            .onAppear {
                Task {
                    // TODO: Validate user
                    finished = true
                }
            }
            .onChange(of: finished) {
                // TODO: Update app state
            }
    }

    @ViewBuilder
    var content: some View {
        VStack(alignment: .center, spacing: Spacing.l) {
            Spacer()

            Text("Verification in progress")
                .font(.system(size: Size.s48).bold())

            ProgressView()
            
            Spacer()
        }
        .padding()
        .applyScreenBackground()
    }
}

#Preview {
    ValidationView()
        .preferredColorScheme(.dark)
}
