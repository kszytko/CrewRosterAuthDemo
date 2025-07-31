//
//  NSErrorMapper.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-12.
//
import Foundation

// MARK: - ErrorMapper
public protocol ErrorMapper: Error {
    init(_ error: any Error)
}

extension ErrorMapper {
    public static func map<T>(closure: () async throws -> T) async rethrows -> T {
        do {
            return try await closure()
        } catch {
            throw Self(error)
        }
    }

    public static func map<T>(closure: () throws -> T) rethrows -> T {
        do {
            return try closure()
        } catch {
            throw Self(error)
        }
    }
}

// MARK: - ErrorEquatable
public protocol ErrorEquatable: Equatable, Error {}

extension ErrorEquatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
