//
//  LoginView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import AuthProvider
import UIComponents

// MARK: - LoginView
struct LoginView: View {
    // MARK: SwiftUI Properties
    @State private var viewModel: LoginViewModel
    @FocusState private var focusedField: CustomTextFieldType?

    // MARK: Properties
    private let authHandler: (AuthState) -> Void
    private let authProvider: any AuthProviderProtocol

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol, authHandler: @escaping (AuthState) -> Void) {
        self.authHandler = authHandler
        self.authProvider = authProvider
        self.viewModel = LoginViewModel(authProvider: authProvider)
    }

    // MARK: Content Properties

    // MARK: Content
    var body: some View {
        NavigationStack {
            content
        }
        .sheet(isPresented: $viewModel.showValidationSheet) {
            VerifyEmailView(authProvider: authProvider, onValidationSuccess: viewModel.finaliseVerification)
                .presentationDetents([.medium])
                .presentationCornerRadius(10)
                .presentationBackgroundInteraction(.enabled)
        }
        .onChange(of: viewModel.processState) { _, state in
            guard state == .completed else { return }
            authHandler(.loggedIn)
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
            ResetPasswordView(authProvider: authProvider)
        }
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    var submitButton: some View {
        Button("Log In") {
            loginUser()
        }
        .buttonStyle(ProgressButtonStyle(inProgress: viewModel.processState == .inProgress))
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
