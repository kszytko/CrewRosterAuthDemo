//
//  ActivateAccountView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-03.
//
import SwiftUI

import AuthProvider
import Lottie
import UIComponents

// MARK: - VerifyEmailView
struct VerifyEmailView: View {
    // MARK: SwiftUI Properties
    @State private var viewModel: VerifyEmailViewModel

    // MARK: Properties
    private let onValidationSuccess: (() -> Void)?

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol, onValidationSuccess: (() -> Void)?) {
        self.viewModel = VerifyEmailViewModel(authProvider: authProvider)
        self.onValidationSuccess = onValidationSuccess
    }

    // MARK: Content Properties

    // MARK: Content
    var body: some View {
        content
            .task {
                viewModel.startVerification()
            }
            .onChange(of: viewModel.isEmailVerified) { _, isVerified in
                guard isVerified else { return }
                onValidationSuccess?()
            }
            .onDisappear {
                viewModel.stopVerification()
            }
            .errorAlert(alertError: $viewModel.alertError)
    }

    @ViewBuilder
    var content: some View {
        VStack(alignment: .center, spacing: Spacing.l) {
            LottieView(animation: .named("EmailAnimation"))
                .configure(\.contentMode, to: .scaleAspectFit)
                .looping()

            VStack(alignment: .center, spacing: Spacing.xs) {
                Text("Activate your account.")
                    .font(.title.bold())

                Text("Please check your email to verify your account to continue.")
                    .font(.body)
                    .lineLimit(3)
                    .multilineTextAlignment(.center)
            }

            VStack(alignment: .center, spacing: Spacing.xs) {
                Text("Didn't receive the activation email?\nCheck your spam folder or try again.")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Button("Resend Email") {
                    sendVerificationEmail()
                }
                .disabled(viewModel.emailSent)
            }
        }
        .padding()
        .applyScreenBackground()
    }

    // MARK: Functions
    private func sendVerificationEmail() {
        Task {
            await viewModel.sendVerificationEmail()
        }
    }
}
