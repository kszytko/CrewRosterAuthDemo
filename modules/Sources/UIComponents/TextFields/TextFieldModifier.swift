//
//  TextFieldModifier.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-05.
//
import SwiftUI

// MARK: - TextFieldModifier
struct TextFieldModifier: ViewModifier {
    // MARK: Properties
    var icon: String
    var contentType: UITextContentType
    var keyboardType: UIKeyboardType
    var submitLabel: SubmitLabel
    var isError: Bool

    // MARK: Content Methods

    // MARK: Content
    func body(content: Content) -> some View {
        content
            .frame(height: 20)
            .textContentType(contentType)
            .keyboardType(keyboardType)
            .padding(.vertical, 15)
            .padding(.trailing, 15)
            .padding(.leading, 30)
            .background(alignment: .leading) {
                Image(systemName: icon)
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundStyle(.tertiary)
                    .offset(y: 1)
            }
            .background(Color.gray.opacity(0.2))
            .overlay {
                if isError {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(Color.red)
                }
            }
            .cornerRadius(8)
            .submitLabel(submitLabel)
    }
}

// MARK: - SecureFieldModifier
struct SecureFieldModifier: ViewModifier {
    // MARK: SwiftUI Properties
    @Binding var isHidden: Bool

    // MARK: Content Methods

    // MARK: Content
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .trailing) {
                Image(systemName: isHidden ? "eye.slash" : "eye")
                    .padding(.leading, 10)
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        isHidden.toggle()
                    }
            }
    }
}
