//
//  ResetPasswordViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import SwiftUI

import AuthProvider
import Logger

private let logger = CLogger(category: "ResetPasswordViewModel")

// MARK: - ResetPasswordViewModel
@Observable
@MainActor
final class ResetPasswordViewModel {
    // MARK: Properties
    var showInformationSheet = false
    var processState: ProcessState = .idle
    var emailSent: Bool = false

    var alertError: (any Error)?
    var emailError: (any Error)?

    var email: String = "" {
        didSet {
            emailSent = false
        }
    }

    private let authProvider: any AuthProviderProtocol

    // MARK: Computed Properties
    var disableSubmit: Bool {
        email.isEmpty || emailSent || processState == .inProgress
    }

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol) {
        self.authProvider = authProvider
    }

    // MARK: Functions
    func sendPasswordReset() async {
        processState = .inProgress
        emailSent = true
        cleanUpErrors()

        do {
            try await authProvider.sendPasswordReset(email: email)
        } catch {
            processState = .failed
            handleError(error)
        }

        showInformationSheet = true
        processState = .completed
    }

    private func cleanUpErrors() {
        alertError = nil
    }

    private func handleError(_ error: AuthError) {
        switch error {
        case .networkError, .operationNotAllowed, .keychainError, .invalidEmail:
            logger.error("Showing alert: \(error)")
            alertError = error

        default:
            logger.error("Omitted alert: \(error)")
        }
    }
}
