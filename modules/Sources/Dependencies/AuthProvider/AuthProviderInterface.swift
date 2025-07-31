//
//  AuthProviderProtocol.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-13.
//
import SwiftUI

public protocol AuthProviderProtocol: Sendable {
    func createUser(email: String, password: String) async throws(AuthError)
    func deleteUser() async throws(AuthError)
    func loginUser(email: String, password: String) async throws(AuthError)
    func signOut() async throws(AuthError)
    func sendPasswordReset(email: String) async throws(AuthError)
    func sendEmailVerification() async throws(AuthError)
    func isEmailVerified() async throws(AuthError) -> Bool
    func currentUser() async -> (any UserAdapterProtocol)?
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
