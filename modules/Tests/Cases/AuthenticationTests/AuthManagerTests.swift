//
//  AuthProviderTests.swift
//  CabinCrewRosterTests
//
//  Created by Krzysiek on 2024-12-09.
//

import Foundation
import Testing

@testable import AuthProvider
import Factory

// MARK: - AuthProviderTests
@Suite(.serialized)
final class AuthProviderTests: BaseTestCase, @unchecked Sendable {
    // MARK: Properties
    var sut: AuthProvider!

    // MARK: Lifecycle
    override init() {
        super.init()
        self.sut = AuthProvider()
    }

    deinit {
        sut = .none
    }

    // MARK: Functions
    @Test func shouldCreateValidUser() async throws {
        // Given
        let email = "test@example.com"
        let password = "password123"

        // When
        let user = try await sut.createUser(email: email, password: password)

        // Then
        #expect(user is MockUserService)
        #expect(mockAuthService.invokedCreateUser)
        #expect(mockAuthService.invokedCreateUserParameters ?? ("", "") == (email, password))
    }

    @Test func shouldDeleteUser_ifUserExists() async throws {
        try await sut.deleteUser()

        // Then
        #expect(mockAuthService.invokedCurrentUserGetter)
        #expect(mockUserService.invokedDelete)
    }

    @Test func shouldThrowsErrorDeletingUser_ifUserNotExists() async throws {
        // When
        mockAuthService.stubbedCurrentUser = nil

        await #expect(
            throws: AuthError.userNotFound,
            "An error should be thrown when no exercises are found",
            performing: {
                try await sut.deleteUser()
            }
        )
    }

    @Test func shouldSignInUser() async throws {
        // Given
        let email = "test@example.com"
        let password = "password123"

        // When
        try await sut.loginUser(email: email, password: password)

        // Then
        #expect(mockAuthService.invokedSignIn)
        #expect(mockAuthService.invokedSignInParameters ?? ("", "") == (email, password))
    }

    @Test func shouldSignOutUser() async throws {
        // When
        try await sut.signOut()

        // Then
        #expect(mockAuthService.invokedsignOut)
    }

    @Test func shouldInvokeSendResetPassword_withValidEmail() async throws {
        // Given
        let email = "test@example.com"

        // When
        try await sut.sendPasswordReset(email: email)

        // Then
        #expect(mockAuthService.invokedSendPasswordResetCount == 1)
        #expect(mockAuthService.invokedSendPasswordResetParameters?.email == email)
    }

    @Test func shouldfetchUserReloadAndSend_whenSendingEmailVerification() async throws {
        // When
        try await sut.sendEmailVerification()

        // Then
        #expect(mockAuthService.invokedCurrentUserGetterCount == 1)
        #expect(mockUserService.invokedReloadCount == 1)
        #expect(mockUserService.invokedSendEmailVerificationCount == 1)
    }
}
