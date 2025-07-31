//
//  RegisterViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import AuthProvider
import Logger

private let logger = CLogger(category: "RegisterViewModel")

// MARK: - RegisterViewModel
@MainActor
@Observable
final class RegisterViewModel {
    // MARK: Properties
    var staffNumber: String = ""
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
        staffNumber.isEmpty || email.isEmpty || password.isEmpty || processState == .inProgress
    }

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol) {
        self.authProvider = authProvider
    }

    // MARK: Functions
    func registerUser() async {
        processState = .inProgress
        cleanUpErrors()
        await signOut()

        do {
            try await performUserRegistration()
            try await performEmailVerification()

            showValidationSheet.toggle()
        } catch {
            processState = .failed

            if error is AuthError {
                handleError(error as! AuthError)
            } else {
                alertError = error
            }
        }

        processState = .finalizing
    }

    func finaliseVerification() {
        email.removeAll()
        staffNumber.removeAll()
        password.removeAll()

        showValidationSheet = false
        processState = .completed
    }

    private func cleanUpErrors() {
        alertError = nil
        emailError = nil
        passwordError = nil
    }

    private func signOut() async {
        try? await authProvider.signOut()
    }

    private func performUserRegistration() async throws {
        do {
            try await createUserAndStoreData()
        } catch {
            try? await authProvider.deleteUser()
            throw error
        }
    }

    private func performEmailVerification() async throws {
        do {
            try await authProvider.sendEmailVerification()
        } catch {
            try? await authProvider.signOut()
            throw error
        }
    }

    private func createUserAndStoreData() async throws {
        try await authProvider.createUser(email: email, password: password)
    }

    private func handleError(_ error: AuthError) {
        switch error {
        case .emailAlreadyInUse, .invalidEmail, .userNotFound, .domainNotAllowed:
            emailError = error
        case .weakPassword:
            passwordError = error
        default:
            alertError = error
        }
    }
}
