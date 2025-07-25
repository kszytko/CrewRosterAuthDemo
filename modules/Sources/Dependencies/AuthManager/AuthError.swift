//
//  FirebaseAuthError.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-04.
//
import ErrorMapper
import Foundation

// MARK: - AuthError
public enum AuthError: LocalizedError, ErrorMapper, ErrorEquatable{
    case invalidCredentials
    case emailAlreadyInUse
    case userNotFound
    case userDisabled
    case invalidEmail
    case networkError
    case weakPassword
    case wrongPassword
    case operationNotAllowed
    case keychainError
    case domainNotAllowed
    case requiresRecentLogin
    case unknownError(any Error)

    // MARK: Computed Properties
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            "Invalid credentials."
        case .emailAlreadyInUse:
            "This email is already in use.."
        case .userNotFound:
            "Account not found for the specified user."
        case .userDisabled:
            "Your account has been disabled."
        case .invalidEmail:
            "Email is invalid."
        case .networkError:
            "Network error."
        case .weakPassword:
            "Your password is too weak."
        case .wrongPassword:
            "Password is incorrect."
        case .operationNotAllowed:
            "Sign in with this method is currently disabled."
        case .keychainError:
            "An error occurred while trying to access secure information."
        case .domainNotAllowed:
            "Registration using this email domain is not allowed."
        case .requiresRecentLogin:
            "Recent login required."
        case let .unknownError(error):
            error.localizedDescription
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .emailAlreadyInUse:
            "Try with different email."
        case .userDisabled:
            "Please contact support."
        case .weakPassword:
            "The password must be 6 characters long or more."
        case .requiresRecentLogin:
            "Please re-login and try again."
        default:
            "Please try again."
        }
    }

    // MARK: Lifecycle
    public init(_ error: any Error) {
        // TODO: Map from store error
        self = .unknownError(error)
    }
}
