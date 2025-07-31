//
//  VerifyEmailViewModel.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-06.
//
import SwiftUI

import AuthProvider

@Observable
@MainActor
final class VerifyEmailViewModel {
    // MARK: Static Properties
    static let verificationDelay: Duration = .seconds(5)

    // MARK: Properties
    var alertError: (any Error)?
    var isEmailVerified: Bool = false
    var emailSent: Bool = false

    private var verificationTask: Task<Void, Never>?
    private let authProvider: any AuthProviderProtocol

    // MARK: Lifecycle
    init(authProvider: any AuthProviderProtocol) {
        self.authProvider = authProvider
    }

    // MARK: Functions
    func sendVerificationEmail() async {
        do {
            emailSent = true
            try await authProvider.sendEmailVerification()
        } catch {
            alertError = error
        }
    }

    func startVerification() {
        verificationTask?.cancel() // Ensure no duplicate tasks are running.
        verificationTask = Task { [weak self] in
            guard let self else { return }
            await runVerificationLoop()
        }
    }

    func stopVerification() {
        verificationTask?.cancel()
        verificationTask = nil
    }

    func runVerificationLoop() async {
        do {
            while !Task.isCancelled, !isEmailVerified {
                try await runVerificationStep()
            }
        } catch is CancellationError {
            return // Task cancelled, no further action needed

        } catch {
            alertError = error
            stopVerification()
        }
    }

    private func runVerificationStep() async throws {
        isEmailVerified = try await authProvider.isEmailVerified()
        if !isEmailVerified {
            try await Task.sleep(for: Self.verificationDelay)
        }
    }
}
