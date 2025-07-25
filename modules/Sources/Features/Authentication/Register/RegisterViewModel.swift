//
//  RegisterViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftData
import SwiftUI

import AuthManager
import Factory
import Logger

private let logger = CLogger(category: "RegisterViewModel")

// MARK: - RegisterViewModel
@MainActor
@Observable
class RegisterViewModel {
    // MARK: Properties
    var staffNumber: String = ""
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
        staffNumber.isEmpty || email.isEmpty || password.isEmpty || inProgress
    }

    // MARK: Functions
    func registerUser() async {
        inProgress = true
        cleanUpErrors()
        await signOut()

        do {
            try await performUserRegistration()
            try await performEmailVerification()

            showValidationSheet.toggle()
        } catch {
            if error is AuthError {
                handleError(error as! AuthError)
            } else {
                alertError = error
            }
        }

        inProgress = false
    }

    func finaliseVerification() {
        email.removeAll()
        staffNumber.removeAll()
        password.removeAll()

        showValidationSheet = false
        showWelcomeView = true
    }

    private func cleanUpErrors() {
        alertError = nil
        emailError = nil
        passwordError = nil
    }

    private func signOut() async {
        try? await authManager.signOut()
    }

    private func performUserRegistration() async throws {
        do {
            try await createUserAndStoreData()
        } catch {
            try? await authManager.deleteUser()
            throw error
        }
    }

    private func performEmailVerification() async throws {
        do {
            try await authManager.sendEmailVerification()
        } catch {
            try? await authManager.signOut()
            throw error
        }
    }

    private func createUserAndStoreData() async throws {
        guard let _ = try await authManager.createUser(email: email, password: password) else {
            throw AuthError.operationNotAllowed
        }
        // TODO: Store user on online store
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
