//
//  FirebaseAuthService.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-11-19.
//

import Foundation
import Logger

import Factory

private let logger = CLogger(category: "AuthManager")

// MARK: - AuthManager
public final actor AuthManager: AuthManagerProtocol {
    // MARK: Properties
    @Injected(\.authService) private var authService

    // MARK: Functions
    public func currentUser() async -> (any UserAdapterProtocol)? {
        return try? fetchAuthenticatedUser()
    }

    public func createUser(email: String, password: String) async throws(AuthError) -> (any UserAdapterProtocol)? {
        try await authService.createUser(withEmail: email, password: password)
        return authService.currentUser
    }

    public func deleteUser() async throws(AuthError) {
        let user = try fetchAuthenticatedUser()
        try await user.delete()
    }

    public func loginUser(email: String, password: String) async throws(AuthError) {
        try await authService.signIn(withEmail: email, password: password)
    }

    public func signOut() async throws(AuthError) {
        try authService.signOut()
    }
    
    public func sendPasswordReset(email: String) async throws(AuthError) {
        try await authService.sendPasswordReset(withEmail: email)
    }

    public func sendEmailVerification() async throws(AuthError) {
        let user = try fetchAuthenticatedUser()
        try await user.reload()
        try await user.sendEmailVerification()
    }

    public func isEmailVerified() async throws(AuthError) -> Bool {
        let user = try fetchAuthenticatedUser()
        try await user.reload()
        return user.isEmailVerified
    }

    private func fetchAuthenticatedUser() throws(AuthError) -> (any UserAdapterProtocol) {
        guard let user = authService.currentUser else {
            throw AuthError.userNotFound
        }
        return user
    }
}
