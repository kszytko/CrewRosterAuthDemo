//
//  RegisterView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import AuthProvider
import Design
import UIComponents

// MARK: - RegisterView
struct RegisterView: View {
    // MARK: SwiftUI Properties
    @State private var viewModel: RegisterViewModel
    @FocusState private var focusedField: CustomTextFieldType?

    // MARK: Properties
    private let authHandler: (AuthState) -> Void
    private let authProvider: any AuthProviderProtocol

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol, authHandler: @escaping (AuthState) -> Void) {
        self.authHandler = authHandler
        self.authProvider = authProvider
        self.viewModel = RegisterViewModel(authProvider: authProvider)
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
                .presentationCornerRadius(Size.s12)
        }
        .onChange(of: viewModel.processState) { _, state in
            guard state == .completed else { return }
            authHandler(.registered)
        }
        .onAppear {
            focusedField = .staffNumber
        }
        .errorAlert(alertError: $viewModel.alertError)
    }

    @ViewBuilder
    var content: some View {
        VStack(alignment: .leading, spacing: Spacing.l) {
            title
            fields
            button

            Spacer()
        }
        .padding()
        .applyScreenBackground()
    }

    @ViewBuilder
    var title: some View {
        VStack(alignment: .leading) {
            Text("Create an Account")
                .font(.title.bold())

            Text("Please provide your company email to complete registration.")
                .font(.caption)
                .lineLimit(2)

            Text("⚠ **Cabin crew only** – pilot access not yet supported.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    var fields: some View {
        VStack(alignment: .leading) {
            HStack {
                CustomTextField(fieldType: .staffNumber, text: $viewModel.staffNumber)
                    .focused($focusedField, equals: .staffNumber)
                    .toolbar {
                        if focusedField == .staffNumber {
                            ToolbarItem(placement: .keyboard) {
                                Button("Continue") {
                                    focusedField = .email
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
            }

            CustomTextField(fieldType: .email, text: $viewModel.email, error: viewModel.emailError) {
                focusedField = .password
            }
            .focused($focusedField, equals: .email)

            CustomTextField(fieldType: .newPassword, text: $viewModel.password, error: viewModel.passwordError) {
                registerUser()
            }
            .focused($focusedField, equals: .password)
        }
    }

    @ViewBuilder
    var button: some View {
        Button("Sign Up") {
            registerUser()
        }
        .buttonStyle(ProgressButtonStyle(inProgress: viewModel.processState == .inProgress))
        .disabled(viewModel.disableSubmit)
        .padding(.top)
    }

    // MARK: Functions
    private func registerUser() {
        Task {
            await viewModel.registerUser()
        }
    }
}
