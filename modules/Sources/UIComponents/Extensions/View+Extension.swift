//
//  View+Extension.swift
//  CabinCrewOrganizer
//
//  Created by Krzysiek on 2023-11-19.
//

import SwiftUI

public extension View {
    @ViewBuilder
    @inlinable func `if`(_ condition: Bool, _ transform: @escaping (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
