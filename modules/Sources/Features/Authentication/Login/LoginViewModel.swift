//
//  LoginViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import AuthProvider
import Logger

private let logger = CLogger(category: "LoginViewModel")

// MARK: - LoginViewModel
@Observable
@MainActor
final class LoginViewModel {
    // MARK: Properties
    var email: String = ""
    var password: String = ""

    var showValidationSheet = false
    var processState: ProcessState = .idle
    
    var alertError: (any Error)?
    var emailError: (any Error)?
    var passwordError: (any Error)?

    private let authProvider: any AuthProviderProtocol

    // MARK: Computed Properties
    var disableSubmit: Bool {
        email.isEmpty || password.isEmpty
    }

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol) {
        self.authProvider = authProvider
    }

    // MARK: Functions
    func loginUser() async {
        processState = .inProgress
        cleanUpErrors()
        await signOut()

        do {
            try await loginAndVerifyUser()
        } catch {
            processState = .failed
            handleError(error)
        }

        processState = .finalizing
    }

    func finaliseVerification() {
        email.removeAll()
        password.removeAll()

        showValidationSheet = false
        processState = .completed
    }

    private func signOut() async {
        try? await authProvider.signOut()
    }

    private func loginAndVerifyUser() async throws(AuthError) {
        try await authProvider.loginUser(email: email, password: password)

        guard try await authProvider.isEmailVerified() else {
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
