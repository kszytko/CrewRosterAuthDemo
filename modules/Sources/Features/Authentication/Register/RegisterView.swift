//
//  RegisterView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import Design
import SwiftUI
import UIComponents

// MARK: - RegisterView
struct RegisterView: View {
    // MARK: SwiftUI Properties
    @State var viewModel = RegisterViewModel()

    @FocusState private var focusedField: CustomTextFieldType?

    // MARK: Content Properties

    // MARK: Content
    var body: some View {
        NavigationStack {
            content
        }
        .sheet(isPresented: $viewModel.showValidationSheet) {
            VerifyEmailView(onValidationSuccess: viewModel.finaliseVerification)
                .presentationDetents([.medium])
                .presentationCornerRadius(Size.s12)
        }
        .navigationDestination(isPresented: $viewModel.showWelcomeView) {
            ValidationView()
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
        .buttonStyle(ProgressButtonStyle(inProgress: viewModel.inProgress))
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

#Preview {
    RegisterView()
        .preferredColorScheme(.dark)
}
