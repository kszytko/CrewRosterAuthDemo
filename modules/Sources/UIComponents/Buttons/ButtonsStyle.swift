//
//  ButtonsStyle.swift
//  CabinCrewOrganizer
//
//  Created by Krzysiek on 2024-09-08.
//
import Design
import SwiftUI

// MARK: - ProgressButtonStyle
public struct ProgressButtonStyle: ButtonStyle {
    // MARK: Properties
    private let inProgress: Bool

    // MARK: Lifecycle
    public init(inProgress: Bool) {
        self.inProgress = inProgress
    }

    // MARK: Content Methods

    // MARK: Content
    public func makeBody(configuration: Configuration) -> some View {
        Group {
            if inProgress {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                configuration.label
            }
        }
        .frame(height: 20)
        .padding(15)
        .font(.title3)
        .frame(maxWidth: .infinity)
        .foregroundStyle(configuration.isPressed ? .gray : .white)
        .background(Color.blue)
        .clipShape(Capsule())
    }
}

// MARK: - MainButtonStyle
public struct MainButtonStyle: ButtonStyle {
    // MARK: Lifecycle
    public init() {}

    // MARK: Content Methods

    // MARK: Content
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 20)
            .padding(15)
            .font(.title3)
            .foregroundStyle(configuration.isPressed ? .gray : .white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

// MARK: - LoginButtonStyle
public struct LoginButtonStyle: ButtonStyle {
    // MARK: Lifecycle
    public init() {}

    // MARK: Content Methods

    // MARK: Content
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 20)
            .padding(15)
            .font(.title3)
            .frame(maxWidth: .infinity)
            .foregroundStyle(configuration.isPressed ? .gray : .white)
            .contentShape(Capsule())
    }
}
