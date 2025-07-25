//
//  CustomSecureField.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-14.
//
import SwiftUI

struct CustomSecureField: UIViewRepresentable {
    // MARK: Nested Types
    class Coordinator: NSObject, UITextFieldDelegate {
        // MARK: Properties
        var parent: CustomSecureField

        // MARK: Lifecycle
        init(parent: CustomSecureField) {
            self.parent = parent
        }

        // MARK: Functions
        @objc func textDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    // MARK: SwiftUI Properties
    @Binding var text: String

    // MARK: Properties
    var placeholder: String

    // MARK: Functions
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textDidChange(_:)), for: .editingChanged)

        // Removing yellow background when autofilled
        if let coverView = textField.subviews.first(where: { $0.description.contains("AFUIASPCoverView") }) {
            coverView.backgroundColor = .clear
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
}
