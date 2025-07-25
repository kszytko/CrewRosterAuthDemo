//
//  ResetPasswordView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI
import UIComponents

// MARK: - LoginView
struct ResetPasswordView: View {
    // MARK: Properties
    @State var viewModel = ResetPasswordViewModel()

    @FocusState private var focusedField: CustomTextFieldType?

    // MARK: Content
    var body: some View {
        content
            .sheet(isPresented: $viewModel.showInformationSheet) {
                ResetPasswordConfirmationView()
                    .presentationDetents([.medium])
                    .presentationCornerRadius(10)
                    .presentationBackgroundInteraction(.enabled)
            }
            .onAppear {
                focusedField = .email
            }
            .errorAlert(alertError: $viewModel.alertError)
    }

    @ViewBuilder
    var content: some View {
            VStack(alignment: .leading, spacing: Spacing.l) {
                title
                fields
                submitButton

                Spacer()
            }
            .padding()
            .applyScreenBackground()
    }

    @ViewBuilder
    private var title: some View {
        VStack(alignment: .leading) {
            Text("Forgot your password?")
                .font(.title.bold())

            Text("Enter your email address below and we'll send you a link to reset your password.")
                .font(.caption)
                .lineLimit(2)
        }
    }

    @ViewBuilder
    private var fields: some View {
        CustomTextField(fieldType: .email, text: $viewModel.email, error: viewModel.emailError)
            .focused($focusedField, equals: .email)
    }

    @ViewBuilder
    private var submitButton: some View {
        Button("Reset password") {
            sendPasswordReset()
        }
        .buttonStyle(ProgressButtonStyle(inProgress: viewModel.inProgress))
        .disabled(viewModel.disableSubmit)
        .padding(.top)
    }

    // MARK: Functions
    private func sendPasswordReset() {
        Task {
            await viewModel.sendPasswordReset()
        }
    }
}

#Preview {
    ResetPasswordView()
}
