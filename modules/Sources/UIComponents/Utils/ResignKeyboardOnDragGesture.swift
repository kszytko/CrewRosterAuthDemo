//
//  ResignKeyboardOnDragGesture.swift
//  CabinCrewOrganizer
//
//  Created by Krzysiek on 2024-05-24.
//

import Foundation
import SwiftUI

@MainActor
public func resignKeyboard(withSubmit submit: (() -> Void)? = nil) {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    submit?()
}
