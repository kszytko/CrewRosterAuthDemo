//
//  LoginView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import AuthManager
import SwiftUI
import UIComponents

// MARK: - LoginView
struct LoginView: View {
    // MARK: Properties
    @State var viewModel = LoginViewModel()

    @FocusState private var focusedField: CustomTextFieldType?

    // MARK: Content
    var body: some View {
        NavigationStack {
            content
        }
        .sheet(isPresented: $viewModel.showValidationSheet) {
            VerifyEmailView(onValidationSuccess: viewModel.finaliseVerification)
                .presentationDetents([.medium])
                .presentationCornerRadius(10)
                .presentationBackgroundInteraction(.enabled)
        }
        .navigationDestination(isPresented: $viewModel.showWelcomeView) {
            ValidationView()
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
            resetButton
            submitButton

            Spacer()
        }
        .padding()
        .applyScreenBackground()
    }

    @ViewBuilder
    var title: some View {
        VStack(alignment: .leading) {
            Text("Welcome Back!")
                .font(.title.bold())

            Text("Enter your credentials to log in.")
                .font(.caption)
                .lineLimit(2)
        }
    }

    @ViewBuilder
    var fields: some View {
        VStack {
            CustomTextField(fieldType: .email, text: $viewModel.email, error: viewModel.emailError) {
                focusedField = .password
            }
            .focused($focusedField, equals: .email)

            CustomTextField(fieldType: .password, text: $viewModel.password, error: viewModel.passwordError) {
                loginUser()
            }
            .focused($focusedField, equals: .password)
        }
    }

    @ViewBuilder
    var resetButton: some View {
        NavigationLink("Forgot password?") {
            ResetPasswordView()
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    var submitButton: some View {
        Button("Log In") {
            loginUser()
        }
        .buttonStyle(ProgressButtonStyle(inProgress: viewModel.inProgress))
        .disabled(viewModel.disableSubmit)
    }

    // MARK: Functions
    private func loginUser() {
        Task {
            await viewModel.loginUser()
        }
        resignKeyboard()
    }
}

#Preview("Login") {
    LoginView()
        .preferredColorScheme(.dark)
}
