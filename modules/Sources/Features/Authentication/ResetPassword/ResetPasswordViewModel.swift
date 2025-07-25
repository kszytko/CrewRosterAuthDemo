//
//  ResetPasswordViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-08.
//
import Logger
import SwiftUI
import AuthManager
import Factory

private let logger = CLogger(category: "ResetPasswordViewModel")

// MARK: - ResetPasswordViewModel
@MainActor
@Observable
class ResetPasswordViewModel {
    // MARK: Properties
    var showInformationSheet = false
    var inProgress = false
    var emailSent: Bool = false

    var alertError: (any Error)?
    var emailError: (any Error)?

    @ObservationIgnored @Injected(\.authManager) private var authManager

    // MARK: Computed Properties
    var email: String = "" {
        didSet {
            emailSent = false
        }
    }

    var disableSubmit: Bool {
        email.isEmpty || emailSent || inProgress
    }

    // MARK: Functions
    func sendPasswordReset() async {
        inProgress = true
        emailSent = true
        cleanUpErrors()

        do {
            try await authManager.sendPasswordReset(email: email)
        } catch {
            handleError(error)
        }

        showInformationSheet = true
        inProgress = false
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
