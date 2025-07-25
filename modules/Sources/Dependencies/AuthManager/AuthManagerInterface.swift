//
//  AuthManagerProtocol.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-13.
//
import Factory

extension Container { 
    public var authManager: Factory<any AuthManagerProtocol > {
        Factory(self) { AuthManager() }.shared
    }
}

public protocol AuthManagerProtocol: Sendable {
    func createUser(email: String, password: String) async throws(AuthError) -> (any UserAdapterProtocol)?
    func deleteUser() async throws(AuthError)
    func loginUser(email: String, password: String) async throws(AuthError)
    func signOut() async throws(AuthError)
    func sendPasswordReset(email: String) async throws(AuthError)
    func sendEmailVerification() async throws(AuthError)
    func isEmailVerified() async throws(AuthError) -> Bool
    func currentUser() async -> (any UserAdapterProtocol)?
}
