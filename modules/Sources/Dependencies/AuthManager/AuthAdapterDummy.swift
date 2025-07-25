//
//  AuthServiceDummy.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-04.
//
import Logger

private let logger = CLogger(category: "AuthServiceDummy")

// MARK: - AuthServiceDummy
public struct AuthServiceDummy: AuthServiceProtocol {
    // MARK: Computed Properties
    public var currentUser: (any UserAdapterProtocol)? {
        UserAdapterDummy()
    }

    // MARK: Lifecycle

    public init() {}

    // MARK: Functions
    public func createUser(withEmail email: String, password: String) async throws(AuthError) {
        logger.info("Attempting to create user with email: \(email)")

        let possibleErrors: [AuthError?] = [.emailAlreadyInUse, .weakPassword, .invalidEmail]
        guard let randomError = possibleErrors.randomElement()! else {
            logger.info("User created successfully.")
            return
        }
        throw randomError
    }

    public func signIn(withEmail email: String, password: String) async throws(AuthError) {
        logger.info("Attempting to signIn with email: \(email)")
        logger.info("User signIn successfully.")
    }

    public func signOut() throws(AuthError) {
        logger.info("Attempting to signOut.")
        logger.info("signOut successfully.")
    }

    public func sendPasswordReset(withEmail email: String) async throws(AuthError) {
        logger.info("Attempting to reset password for email: \(email)")
        logger.info("Reset email sended successfully.")
    }
}

// MARK: - UserAdapterDummy
public final class UserAdapterDummy: UserAdapterProtocol {
    // MARK: Properties
    public let uid: String
    public let email: String?
    public let isEmailVerified: Bool

    // MARK: Lifecycle
    public init(isVerified: Bool = false, uid: String = "", email: String? = nil) {
        self.isEmailVerified = isVerified
        self.uid = uid
        self.email = email
    }

    // MARK: Functions
    public func reload() async throws(AuthError) {
        logger.info("Attempting to reload.")
        logger.info("Reloaded successfully")
    }

    public func sendEmailVerification() async throws(AuthError) {
        logger.info("Attempting to send email verification.")
        logger.info("Email verification sent successfully")
    }

    public func delete() async throws(AuthError) {
        logger.info("Deleting user account.")
        logger.info("Deleted.")
    }
}
