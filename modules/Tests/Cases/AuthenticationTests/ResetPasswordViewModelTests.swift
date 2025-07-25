//
//  ResetPasswordViewModel.swift
//  CabinCrewRosterTests
//
//  Created by Krzysiek on 2024-12-10.
//
import Factory
import Foundation
import Testing

@testable import Authentication
import AuthManager

// MARK: - AuthManagerTests
@Suite(.serialized)
@MainActor
final class ResetPasswordViewModelTests: BaseTestCase, @unchecked Sendable {
    // MARK: Properties
    var sut: ResetPasswordViewModel!

    let email = "test@example.com"

    // MARK: Lifecycle
    override init() {
        super.init()
        self.sut = ResetPasswordViewModel()
    }

    deinit {
        sut = .none
    }

    // MARK: Functions
    @Test
    func shouldDisableSubmit_whenEmailIsEmpty() {
        // Given
        sut.email = ""

        // Then
        #expect(sut.disableSubmit)
    }

    @Test
    func shouldEnableSubmit_whenEmailIsNotEmpty() {
        // Given
        sut.email = email

        // Then
        #expect(sut.disableSubmit == false)
    }

    @Test
    func showInformationSheet_whenSendPasswordReset() async {
        // Given
        sut.email = email

        // When
        await sut.sendPasswordReset()

        // Then
        #expect(mockAuthManager.invokedSendPasswordResetCount == 1)
        #expect(mockAuthManager.invokedSendPasswordResetParameters?.email == email)

        #expect(sut.alertError == nil)
        #expect(sut.showInformationSheet == true)
    }

    /// Ensures registration fails when creating a user throws an error
    @Test
    func showInformationSheet_whenSendPasswordResetThrowsError() async throws {
        // Given
        sut.email = email
        mockAuthManager.stubbedSendPasswordResetError = AuthError.invalidEmail

        // When
        await sut.sendPasswordReset()

        // Then
        #expect(mockAuthManager.invokedSendPasswordResetCount == 1)
        #expect(mockAuthManager.invokedSendPasswordResetParameters?.email == email)

        let authError = try #require(sut.alertError as? AuthError)
        #expect(authError == AuthError.invalidEmail)
        #expect(sut.showInformationSheet == true)
    }
}
