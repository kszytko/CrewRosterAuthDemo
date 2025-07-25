//
//  CustomTextField.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-06.
//
import SwiftUI

// MARK: - CustomTextFieldType
public enum CustomTextFieldType {
    case email
    case password
    case newPassword
    case staffNumber

    // MARK: Computed Properties
    public var title: String {
        switch self {
        case .email: "Email"
        case .password, .newPassword: "Password"
        case .staffNumber: "Staff number"
        }
    }

    public var icon: String {
        switch self {
        case .email: "envelope"
        case .password, .newPassword: "lock"
        case .staffNumber: "person"
        }
    }

    public var contentType: UITextContentType {
        switch self {
        case .email: .username
        case .password: .password
        case .newPassword: .newPassword
        case .staffNumber:.oneTimeCode
        }
    }

    public var keyboardType: UIKeyboardType {
        switch self {
        case .email: .emailAddress
        case .password, .newPassword: .default
        case .staffNumber: .numberPad
        }
    }

    public var submitLabel: SubmitLabel {
        switch self {
        case .email: .continue
        case .password, .newPassword: .done
        case .staffNumber:.continue
        }
    }

    public var isSecure: Bool {
        self == .password || self == .newPassword
    }
}

// MARK: - CustomTextField
public struct CustomTextField: View {
    // MARK: SwiftUI Properties
    @Binding private var text: String
    @State private var isHidden: Bool = true

    // MARK: Properties
    private let fieldType: CustomTextFieldType
    private var error: (any Error)?
    private var onSubmit: (() -> Void)?

    // MARK: Computed Properties
    private var title: String { fieldType.title }
    private var icon: String { fieldType.icon }
    private var isSecure: Bool { fieldType.isSecure }
    private var contentType: UITextContentType { fieldType.contentType }
    private var keyboardType: UIKeyboardType { fieldType.keyboardType }
    private var submitLabel: SubmitLabel { fieldType.submitLabel }

    // MARK: Lifecycle
    public init(fieldType: CustomTextFieldType, text: Binding<String>, error: (any Error)? = nil, onSubmit: (() -> Void)? = nil) {
        self.fieldType = fieldType
        self.onSubmit = onSubmit
        _text = text
        self.error = error
    }

    // MARK: Content Properties

    // MARK: Content
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                if !isSecure || !isHidden {
                    TextField(title, text: $text)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                } else {
                    CustomSecureField(text: $text, placeholder: title)
                }
            }
            .if(isSecure) { view in
                view.modifier(SecureFieldModifier(isHidden: $isHidden))
            }
            .modifier(TextFieldModifier(
                icon: icon,
                contentType: contentType,
                keyboardType: keyboardType,
                submitLabel: submitLabel,
                isError: error != nil
            ))
            .onSubmit {
                onSubmit?()
            }

            if let error {
                Text(error.localizedDescription)
                    .foregroundStyle(.red)
                    .font(.caption)
                    .frame(height: 10)
            }
        }
    }
}
