//
//  LoginViewModelTests.swift
//  CabinCrewRosterTests
//
//  Created by Krzysiek on 2024-12-10.
//
import Foundation
import Testing

@testable import Authentication
import AuthManager
import Factory

// MARK: - AuthManagerTests
@Suite(.serialized)
final class VerifyEmailViewModelTests: BaseTestCase, @unchecked Sendable {
    // MARK: Properties
    var sut: VerifyEmailViewModel!

    let email = "test@example.com"
    let password = "password123"
    let userID = "testID"

    // MARK: Lifecycle
    override init() {
        super.init()
        self.sut = VerifyEmailViewModel()
    }

    deinit {
        sut = .none
    }

    // MARK: Functions
    @Test
    func verificationStops_WhenEmailVerifiedImmediately() async {
        mockAuthManager.stubbedIsEmailVerifiedResult = true
        await sut.runVerificationLoop()

        #expect(sut.isEmailVerified == true)
        #expect(mockAuthManager.invokedIsEmailVerifiedCount == 1)
        #expect(sut.alertError == nil)
    }

    @Test
    func verificationRetriesUntilSuccess() async {
        // Given
        mockAuthManager.stubbedIsEmailVerifiedClosure = { invokedIsEmailVerifiedCount in
            invokedIsEmailVerifiedCount >= 5
        }

        await sut.runVerificationLoop()

        #expect(sut.isEmailVerified == true)
        #expect(mockAuthManager.invokedIsEmailVerifiedCount == 5)
        #expect(sut.alertError == nil)
    }

    @Test
    func verificationHandlesError_AndStops() async throws {
        // Ustaw odpowiedź zwracającą true od razu.
        mockAuthManager.stubbedIsEmailVerifiedError = AuthError.invalidEmail

        await sut.runVerificationLoop()

        #expect(sut.isEmailVerified == false)
        #expect(mockAuthManager.invokedIsEmailVerifiedCount == 1)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.invalidEmail)
    }
}
