//
//  LoginViewModelTests.swift
//  CabinCrewRosterTests
//
//  Created by Krzysiek on 2024-12-10.
//
import Foundation
import Testing

@testable import Authentication
import AuthProvider
import Factory

// MARK: - AuthProviderTests
@Suite(.serialized)
@MainActor
final class LoginViewModelTests: BaseTestCase, @unchecked Sendable {
    // MARK: Properties

    var sut: LoginViewModel!

    let email = "test@example.com"
    let password = "password123"
    let userID = "testID"

    // MARK: Lifecycle

    override init() {
        super.init()
        self.sut = LoginViewModel()
    }

    deinit {
        sut = .none
    }

    // MARK: Functions

    @Test(arguments: [
        ("test@example.com", "", true),
        ("", "password123", true),
        ("", "", true),
        ("test@example.com", "password123", false),
    ])
    func shouldDisableSubmit_whenEmailOrPasswordIsEmpty(
        email: String,
        password: String,
        expectation: Bool
    ) async throws {
        // Given
        sut.email = email
        sut.password = password

        // Then
        #expect(sut.disableSubmit == expectation)
    }

    @Test
    func loginUser_succeeds_whenEmailVerified() async {
        // Given
        sut.email = email
        sut.password = password
        mockAuthProvider.stubbedIsEmailVerifiedResult = true

        // When
        await sut.loginUser()

        // Then
        #expect(mockAuthProvider.invokedLoginUserCount == 1)
        #expect(mockAuthProvider.invokedLoginUserParameters?.email == email)
        #expect(mockAuthProvider.invokedLoginUserParameters?.password == password)

        #expect(mockAuthProvider.invokedIsEmailVerifiedCount == 1)

        #expect(sut.alertError == nil)
        #expect(sut.showValidationSheet == false)
    }

    /// Ensures registration fails when creating a user throws an error
    @Test
    func loginUser_fails_whenLoginUserThrowsError() async throws {
        // Given
        sut.email = email
        sut.password = password
        mockAuthProvider.stubbedLoginUserError = AuthError.networkError

        // When
        await sut.loginUser()

        // Then
        #expect(mockAuthProvider.invokedLoginUserCount == 1)
        #expect(mockAuthProvider.invokedIsEmailVerifiedCount == 0)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.networkError)
        #expect(sut.showValidationSheet == false)
    }

    @Test
    func loginUser_throwsInvalidCredential_whenUserNotFoundOrWrongPassword() async throws {
        // When
        mockAuthProvider.stubbedLoginUserError = AuthError.userNotFound
        await sut.loginUser()

        // Then
        var authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.invalidCredentials)

        // When
        mockAuthProvider.stubbedLoginUserError = AuthError.wrongPassword
        await sut.loginUser()

        // Then
        authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.invalidCredentials)

        // When
        mockAuthProvider.stubbedLoginUserError = AuthError.invalidEmail
        await sut.loginUser()

        // Then
        authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.invalidCredentials)
    }

    /// Ensures registration fails when saving user data throws an error
    @Test
    func loginUser_fails_whenEmailVerificationThrowsError() async throws {
        // Given
        sut.email = email
        sut.password = password
        mockAuthProvider.stubbedIsEmailVerifiedError = AuthError.networkError

        // When
        await sut.loginUser()

        // Then
        #expect(mockAuthProvider.invokedLoginUserCount == 1)
        #expect(mockAuthProvider.invokedIsEmailVerifiedCount == 1)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.networkError)
        #expect(sut.showValidationSheet == false)
    }

    /// Ensures validation sheet is toggled when registration succeeds
    @Test
    func loginUser_togglesValidationSheet_whenEmailNotVerified() async {
        // Given
        sut.email = email
        sut.password = password
        mockAuthProvider.stubbedIsEmailVerifiedResult = false

        // When
        await sut.loginUser()

        #expect(mockAuthProvider.invokedLoginUserCount == 1)
        #expect(mockAuthProvider.invokedIsEmailVerifiedCount == 1)

        // Then
        #expect(sut.alertError == nil)
        #expect(sut.showValidationSheet == true)
    }

    /// Ensures authentication error is set when an error occurs
    @Test
    func loginUser_setsAuthError_whenErrorOccurs() async throws {
        // When
        sut.alertError = nil
        mockAuthProvider.stubbedLoginUserError = AuthError.networkError
        await sut.loginUser()

        // Then
        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.networkError)
    }

    /// Ensures validation sheet is not toggled when registration fails
    @Test
    func loginUser_doesNotToggleValidationSheet_whenRegistrationFails() async {
        // When
        mockAuthProvider.stubbedLoginUserError = AuthError.networkError
        await sut.loginUser()

        // Then
        #expect(sut.showValidationSheet == false)
    }
}
