//
//  MockAuthManager.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-11.
//
import Foundation
import AuthManager

public class MockAuthManager: AuthManagerProtocol, @unchecked Sendable{
    var invokedCurrentUser = false
    var invokedCurrentUserCount = 0
    var stubbedCurrentUserResult: UserAdapterProtocol!
    
    public init(){}
    
    public func currentUser() -> (any UserAdapterProtocol)? {
        invokedCurrentUser = true
        invokedCurrentUserCount += 1
        return stubbedCurrentUserResult
    }

    var invokedCreateUser = false
    var invokedCreateUserCount = 0
    var invokedCreateUserParameters: (email: String, password: String)?
    var invokedCreateUserParametersList = [(email: String, password: String)]()
    var stubbedCreateUserError: AuthError?
    var stubbedCreateUserResult: UserAdapterProtocol!

    public func createUser(email: String, password: String) async throws(AuthError) -> UserAdapterProtocol? {
        invokedCreateUser = true
        invokedCreateUserCount += 1
        invokedCreateUserParameters = (email, password)
        invokedCreateUserParametersList.append((email, password))
        if let error = stubbedCreateUserError {
            throw error
        }
        return stubbedCreateUserResult
    }

    var invokedDeleteUser = false
    var invokedDeleteUserCount = 0
    var stubbedDeleteUserError: AuthError?

    public func deleteUser() async throws(AuthError) {
        invokedDeleteUser = true
        invokedDeleteUserCount += 1
        if let error = stubbedDeleteUserError {
            throw error
        }
    }

    var invokedLoginUser = false
    var invokedLoginUserCount = 0
    var invokedLoginUserParameters: (email: String, password: String)?
    var invokedLoginUserParametersList = [(email: String, password: String)]()
    var stubbedLoginUserError: AuthError?

    public func loginUser(email: String, password: String) async throws(AuthError) {
        invokedLoginUser = true
        invokedLoginUserCount += 1
        invokedLoginUserParameters = (email, password)
        invokedLoginUserParametersList.append((email, password))
        if let error = stubbedLoginUserError {
            throw error
        }
    }

    var invokedsignOut = false
    var invokedsignOutCount = 0
    var stubbedsignOutError: AuthError?

    public func signOut() throws(AuthError) {
        invokedsignOut = true
        invokedsignOutCount += 1
        if let error = stubbedsignOutError {
            throw error
        }
    }

    var invokedSendPasswordReset = false
    var invokedSendPasswordResetCount = 0
    var invokedSendPasswordResetParameters: (email: String, Void)?
    var invokedSendPasswordResetParametersList = [(email: String, Void)]()
    var stubbedSendPasswordResetError: AuthError?

    public func sendPasswordReset(email: String) async throws(AuthError) {
        invokedSendPasswordReset = true
        invokedSendPasswordResetCount += 1
        invokedSendPasswordResetParameters = (email, ())
        invokedSendPasswordResetParametersList.append((email, ()))
        if let error = stubbedSendPasswordResetError {
            throw error
        }
    }

    var invokedSendEmailVerification = false
    var invokedSendEmailVerificationCount = 0
    var stubbedSendEmailVerificationError: AuthError?

    public func sendEmailVerification() async throws(AuthError) {
        invokedSendEmailVerification = true
        invokedSendEmailVerificationCount += 1
        if let error = stubbedSendEmailVerificationError {
            throw error
        }
    }

    var invokedIsEmailVerified = false
    var invokedIsEmailVerifiedCount = 0
    var stubbedIsEmailVerifiedError: AuthError?
    var stubbedIsEmailVerifiedResult: Bool! = false
    var stubbedIsEmailVerifiedClosure: ((Int) -> Bool)?

    @MainActor
    public func isEmailVerified() async throws(AuthError) -> Bool {
        invokedIsEmailVerified = true
        invokedIsEmailVerifiedCount += 1
        if let error = stubbedIsEmailVerifiedError {
            throw error
        }
        if let stubbedIsEmailVerifiedClosure{
            return stubbedIsEmailVerifiedClosure(invokedIsEmailVerifiedCount)
        }
        return stubbedIsEmailVerifiedResult
    }
}
