//
//  RegisterViewModelTests.swift
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
@MainActor
final class RegisterViewModelTests: BaseTestCase, @unchecked Sendable {
    // MARK: Properties

    var sut: RegisterViewModel!

    let email = "test@example.com"
    let password = "password123"
    let staffNumber = "123123"
    let userID = "testID"

    // MARK: Lifecycle
    override init() {
        super.init()
        self.sut = RegisterViewModel()
    }

    deinit {
        sut = .none
    }

    // MARK: Functions
    @Test(arguments: [
        ("test@example.com", "", "123", true),
        ("", "password123", "123", true),
        ("", "", "123", true),
        ("", "", "", true),
        ("test@example.com", "password123", "123", false),
    ])
    func shouldDisableSubmit_whenEmailOrPasswordIsEmpty(
        email: String,
        password: String,
        staffNumber: String,
        expectation: Bool
    ) async throws {
        // Given
        sut.email = email
        sut.password = password
        sut.staffNumber = staffNumber

        // Then
        #expect(sut.disableSubmit == expectation)
    }

    @Test
    func registerUser_succeeds_whenAllStepsAreSuccessful() async {
        // Given
        let userData = MockUserService()
        userData.stubbedUid = userID

        // When
        sut.email = email
        sut.password = password
        sut.staffNumber = staffNumber
        mockAuthManager.stubbedCreateUserResult = userData

        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedCreateUserParameters?.email == email)
        #expect(mockAuthManager.invokedCreateUserParameters?.password == password)

        #expect(mockAuthManager.invokedDeleteUserCount == 0)

        #expect(mockAuthManager.invokedSendEmailVerificationCount == 1)
        #expect(mockAuthManager.invokedsignOutCount == 1)

        #expect(sut.alertError == nil)
    }

    /// Ensures registration fails when creating a user throws an error
    @Test
    func registerUser_fails_whenCreateUserThrowsError() async throws {
        // Given
        sut.email = email
        sut.password = password
        sut.staffNumber = staffNumber

        let userData = MockUserService()
        userData.stubbedUid = userID

        mockAuthManager.stubbedCreateUserResult = MockUserService()
        mockAuthManager.stubbedCreateUserError = AuthError.wrongPassword

        // When
        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedCreateUserParameters?.email == email)
        #expect(mockAuthManager.invokedCreateUserParameters?.password == password)
        #expect(mockAuthManager.invokedDeleteUserCount == 1)

        #expect(mockAuthManager.invokedSendEmailVerificationCount == 0)
        #expect(mockAuthManager.invokedsignOutCount == 1)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.wrongPassword)
        #expect(sut.showValidationSheet == false)
    }

    @Test
    func registerUser_fails_whenCreateUserReturnNil() async throws {
        // Given
        sut.email = email
        sut.password = password

        mockAuthManager.stubbedCreateUserResult = nil

        // When
        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedCreateUserParameters?.email == email)
        #expect(mockAuthManager.invokedCreateUserParameters?.password == password)
        #expect(mockAuthManager.invokedDeleteUserCount == 1)

        #expect(mockAuthManager.invokedSendEmailVerificationCount == 0)
        #expect(mockAuthManager.invokedsignOutCount == 1)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.operationNotAllowed)
        #expect(sut.showValidationSheet == false)
    }

    /// Ensures registration fails when saving user data throws an error
    @Test
    func registerUser_fails_whenSaveUserDataThrowsError() async throws {
        // Given
        let userData = MockUserService()
        userData.stubbedUid = userID

        // When
        sut.email = email
        sut.password = password
        sut.staffNumber = staffNumber

        mockAuthManager.stubbedCreateUserResult = userData
        mockAuthManager.stubbedCreateUserError = AuthError.operationNotAllowed

        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedCreateUserParameters?.email == email)
        #expect(mockAuthManager.invokedCreateUserParameters?.password == password)
        #expect(mockAuthManager.invokedDeleteUserCount == 1)

        #expect(mockAuthManager.invokedSendEmailVerificationCount == 0)
        #expect(mockAuthManager.invokedsignOutCount == 1)

        let storeError = try #require(sut.alertError as? AuthError)
        #expect(storeError == AuthError.operationNotAllowed)
        #expect(sut.showValidationSheet == false)
    }

    /// Ensures user is deleted when an error occurs during registration
    @Test
    func registerUser_deletesUser_whenErrorOccursDuringRegistration() async {
        // Given
        sut.email = email
        sut.password = password

        mockAuthManager.stubbedCreateUserResult = MockUserService()

        // When
        mockAuthManager.stubbedCreateUserError = AuthError.wrongPassword
        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedDeleteUserCount == 1)
    }

    /// Ensures registration fails when sending email verification throws an error
    @Test
    func registerUser_failsAndSignsOut_whenSendEmailVerificationThrowsError() async throws {
        // Given
        sut.email = email
        sut.password = password
        sut.staffNumber = staffNumber

        let userData = MockUserService()
        userData.stubbedUid = userID
        mockAuthManager.stubbedCreateUserResult = MockUserService()

        // When
        mockAuthManager.stubbedSendEmailVerificationError = AuthError.networkError
        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedCreateUserCount == 1)
        #expect(mockAuthManager.invokedDeleteUserCount == 0)

        #expect(mockAuthManager.invokedSendEmailVerificationCount == 1)
        #expect(mockAuthManager.invokedsignOutCount == 2)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.networkError)
        #expect(sut.showValidationSheet == false)
    }

    /// Ensures validation sheet is toggled when registration succeeds
    @Test
    func registerUser_togglesValidationSheet_whenRegistrationSucceeds() async {
        // When
        mockAuthManager.stubbedCreateUserResult = MockUserService()

        await sut.registerUser()

        // Then
        #expect(sut.showValidationSheet == true)
    }

    /// Ensures authentication error is set when an error occurs
    @Test(arguments: [AuthError.emailAlreadyInUse, AuthError.invalidEmail, AuthError.userNotFound, AuthError.domainNotAllowed])
    func registerUser_setsEmailError_whenErrorOccurs(error: AuthError) async {
        // When
        mockAuthManager.stubbedCreateUserError = error
        await sut.registerUser()

        // Then
        #expect(sut.emailError as? AuthError == error)
    }

    @Test(arguments: [AuthError.weakPassword])
    func registerUser_setsPasswordError_whenErrorOccurs(error: AuthError) async {
        // When
        mockAuthManager.stubbedCreateUserError = error
        await sut.registerUser()

        // Then
        #expect(sut.passwordError as? AuthError == error)
    }

    @Test(arguments: [AuthError.keychainError, AuthError.operationNotAllowed, AuthError.invalidCredentials])
    func registerUser_setAlertError_whenErrorOccurs(error: AuthError) async throws {
        // When
        mockAuthManager.stubbedCreateUserError = error
        await sut.registerUser()

        // Then
        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == error)
    }

    /// Ensures email verification is not sent when registration fails
    @Test
    func registerUser_doesNotSendEmailVerification_whenRegistrationFails() async {
        // When
        mockAuthManager.stubbedCreateUserError = AuthError.networkError
        await sut.registerUser()

        // Then
        #expect(mockAuthManager.invokedSendEmailVerificationCount == 0)
    }

    /// Ensures validation sheet is not toggled when registration fails
    @Test
    func registerUser_doesNotToggleValidationSheet_whenRegistrationFails() async {
        // When
        mockAuthManager.stubbedCreateUserError = AuthError.networkError
        await sut.registerUser()

        // Then
        #expect(sut.showValidationSheet == false)
    }
}
