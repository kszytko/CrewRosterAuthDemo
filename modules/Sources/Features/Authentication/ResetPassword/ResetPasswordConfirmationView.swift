//
//  InformationSheetView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import Lottie
import UIComponents

// MARK: - VerifyEmailView
struct ResetPasswordConfirmationView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            LinearGradient(colors: [.blue, .black, .black], startPoint: .topLeading, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(alignment: .center, spacing: Spacing.l) {
                LottieView(animation: .named("EmailAnimation"))
                    .configure(\.contentMode, to: .scaleAspectFit)
                    .looping()

                VStack(alignment: .center, spacing: Spacing.xs) {
                    Text("Reset your password.")
                        .font(.title.bold())

                    Text("Please check your email to reset your password.")
                        .font(.body)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                }

                Text("Didn't receive the email?\nCheck your spam folder or try again.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}
