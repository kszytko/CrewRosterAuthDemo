//
//  LoginViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import AuthManager
import Factory
import Logger
import SwiftUI

private let logger = CLogger(category: "LoginViewModel")

// MARK: - LoginViewModel
@MainActor
@Observable
final class LoginViewModel {
    // MARK: Properties
    var email: String = ""
    var password: String = ""

    var showValidationSheet = false
    var showWelcomeView = false
    var inProgress = false

    var alertError: (any Error)?
    var emailError: (any Error)?
    var passwordError: (any Error)?

    @ObservationIgnored @Injected(\.authManager) private var authManager

    // MARK: Computed Properties
    var disableSubmit: Bool {
        email.isEmpty || password.isEmpty
    }

    // MARK: Functions
    func loginUser() async {
        inProgress = true
        cleanUpErrors()
        await signOut()

        do {
            try await loginAndVerifyUser()
        } catch {
            handleError(error)
        }

        inProgress = false
    }

    func finaliseVerification() {
        email.removeAll()
        password.removeAll()

        showValidationSheet = false
        showWelcomeView = true
    }

    private func signOut() async {
        try? await authManager.signOut()
    }

    private func loginAndVerifyUser() async throws(AuthError) {
        try await authManager.loginUser(email: email, password: password)

        guard try await authManager.isEmailVerified() else {
            showValidationSheet = true
            return
        }

        finaliseVerification()
    }

    private func cleanUpErrors() {
        alertError = nil
        emailError = nil
        passwordError = nil
    }

    private func handleError(_ error: AuthError) {
        switch error {
        case .domainNotAllowed:
            emailError = error
        case .userNotFound, .wrongPassword, .invalidEmail:
            alertError = AuthError.invalidCredentials
        default:
            alertError = error
        }
    }
}
