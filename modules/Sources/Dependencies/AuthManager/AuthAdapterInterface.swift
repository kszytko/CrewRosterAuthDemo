//
//  AuthService.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-04.
//
import Factory

public extension Container {
    var authService: Factory<any AuthServiceProtocol> {
        Factory(self) { AuthServiceDummy() }
    }
}

// MARK: - AuthServiceProtocol
public protocol AuthServiceProtocol: Sendable {
    var currentUser: (any UserAdapterProtocol)? { get }
    func createUser(withEmail email: String, password: String) async throws(AuthError)
    func signIn(withEmail email: String, password: String) async throws(AuthError)
    func signOut() throws(AuthError)
    func sendPasswordReset(withEmail email: String) async throws(AuthError)
}

// MARK: - UserAdapterProtocol
public protocol UserAdapterProtocol: Sendable {
    var isEmailVerified: Bool { get }
    var uid: String { get }
    var email: String? { get }
    func reload() async throws(AuthError)
    func sendEmailVerification() async throws(AuthError)
    func delete() async throws(AuthError)
}
