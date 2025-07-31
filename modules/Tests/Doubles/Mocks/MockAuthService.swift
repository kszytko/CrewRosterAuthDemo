//
//  MockAuthService.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-10.
//
import Foundation
import AuthProvider

class MockAuthService: AuthServiceProtocol, @unchecked Sendable{
    var invokedCurrentUserGetter = false
    var invokedCurrentUserGetterCount = 0
    var stubbedCurrentUser: UserAdapterProtocol?

    init(user: UserAdapterProtocol? = nil){
        stubbedCurrentUser = user
    }
    
    var currentUser: UserAdapterProtocol? {
        invokedCurrentUserGetter = true
        invokedCurrentUserGetterCount += 1
        return stubbedCurrentUser
    }

    var invokedCreateUser = false
    var invokedCreateUserCount = 0
    var invokedCreateUserParameters: (email: String, password: String)?
    var invokedCreateUserParametersList = [(email: String, password: String)]()
    var stubbedCreateUserError: AuthError?

    func createUser(withEmail email: String, password: String) throws(AuthError) {
        invokedCreateUser = true
        invokedCreateUserCount += 1
        invokedCreateUserParameters = (email, password)
        invokedCreateUserParametersList.append((email, password))
        if let error = stubbedCreateUserError {
            throw error
        }
    }

    var invokedSignIn = false
    var invokedSignInCount = 0
    var invokedSignInParameters: (email: String, password: String)?
    var invokedSignInParametersList = [(email: String, password: String)]()
    var stubbedSignInError: AuthError?

    func signIn(withEmail email: String, password: String) throws(AuthError) {
        invokedSignIn = true
        invokedSignInCount += 1
        invokedSignInParameters = (email, password)
        invokedSignInParametersList.append((email, password))
        if let error = stubbedSignInError {
            throw error
        }
    }

    var invokedsignOut = false
    var invokedsignOutCount = 0
    var stubbedsignOutError: AuthError?

    func signOut() throws(AuthError) {
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

    func sendPasswordReset(withEmail email: String) throws(AuthError) {
        invokedSendPasswordReset = true
        invokedSendPasswordResetCount += 1
        invokedSendPasswordResetParameters = (email, ())
        invokedSendPasswordResetParametersList.append((email, ()))
        if let error = stubbedSendPasswordResetError {
            throw error
        }
    }
}

class MockUserService: UserAdapterProtocol, @unchecked Sendable{
    var invokedIsEmailVerifiedGetter = false
    var invokedIsEmailVerifiedGetterCount = 0
    var stubbedIsEmailVerified: Bool! = false

    var isEmailVerified: Bool {
        invokedIsEmailVerifiedGetter = true
        invokedIsEmailVerifiedGetterCount += 1
        return stubbedIsEmailVerified
    }

    var invokedUidGetter = false
    var invokedUidGetterCount = 0
    var stubbedUid: String! = ""

    var uid: String {
        invokedUidGetter = true
        invokedUidGetterCount += 1
        return stubbedUid
    }

    var invokedEmailGetter = false
    var invokedEmailGetterCount = 0
    var stubbedEmail: String!

    var email: String? {
        invokedEmailGetter = true
        invokedEmailGetterCount += 1
        return stubbedEmail
    }

    var invokedReload = false
    var invokedReloadCount = 0
    var stubbedReloadError: AuthError?

    func reload() throws(AuthError) {
        invokedReload = true
        invokedReloadCount += 1
        if let error = stubbedReloadError {
            throw error
        }
    }

    var invokedSendEmailVerification = false
    var invokedSendEmailVerificationCount = 0
    var stubbedSendEmailVerificationError: AuthError?

    func sendEmailVerification() throws(AuthError) {
        invokedSendEmailVerification = true
        invokedSendEmailVerificationCount += 1
        if let error = stubbedSendEmailVerificationError {
            throw error
        }
    }

    var invokedDelete = false
    var invokedDeleteCount = 0
    var stubbedDeleteError: AuthError?

    func delete() throws(AuthError) {
        invokedDelete = true
        invokedDeleteCount += 1
        if let error = stubbedDeleteError {
            throw error
        }
    }
}

