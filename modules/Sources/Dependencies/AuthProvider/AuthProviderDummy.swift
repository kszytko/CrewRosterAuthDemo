//
//  FirebaseAuthService.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-11-19.
//

import Foundation
import Logger

private let logger = CLogger(category: "AuthProvider")

// MARK: - AuthProviderDummy
public final actor AuthProviderDummy: AuthProviderProtocol {
    // MARK: Lifecycle
    public init() {}

    // MARK: Functions
    public func currentUser() async -> (any UserAdapterProtocol)? {
        logger.debug("currentUser() called")
        return nil
    }

    public func createUser(email: String, password: String) async throws(AuthError) {
        logger.info("createUser(email: \(email)) called")
    }

    public func deleteUser() async throws(AuthError) {
        logger.info("deleteUser() called")
    }

    public func loginUser(email: String, password: String) async throws(AuthError) {
        logger.info("loginUser(email: \(email)) called")
    }

    public func signOut() async throws(AuthError) {
        logger.info("signOut() called")
    }

    public func sendPasswordReset(email: String) async throws(AuthError) {
        logger.info("sendPasswordReset(email: \(email)) called")
    }

    public func sendEmailVerification() async throws(AuthError) {
        logger.info("sendEmailVerification() called")
    }

    public func isEmailVerified() async throws(AuthError) -> Bool {
        logger.debug("isEmailVerified() called")
        return false
    }
}
