//
//  ErrorAlertModifier.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-06.
//
import SwiftUI

// MARK: - ErrorAlertModifier
struct ErrorAlertModifier: ViewModifier {
    // MARK: SwiftUI Properties
    @Binding var alertError: (any Error)?
    @State private var isPresented = false

    // MARK: Content Methods

    // MARK: Content

    func body(content: Content) -> some View {
        content
            .alert(isPresented: $isPresented) {
                let localizedError = alertError as? any LocalizedError
                return Alert(
                    title: Text(localizedError?.errorDescription ?? "Error"),
                    message: Text(localizedError?.recoverySuggestion ?? alertError?.localizedDescription ?? "Try again."),
                    dismissButton: .default(Text("OK")) {
                        alertError = nil
                    }
                )
            }
            .onChange(of: alertError?.localizedDescription) { _, newValue in
                isPresented = newValue != nil
            }
    }
}

public extension View {
    func errorAlert(alertError: Binding<(any Error)?>) -> some View {
        modifier(ErrorAlertModifier(alertError: alertError))
    }
}
