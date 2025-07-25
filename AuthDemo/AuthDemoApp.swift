//
//  AuthDemoApp.swift
//  AuthDemo
//
//  Created by Krzysiek on 25/07/2025.
//

import SwiftUI
import Authentication

@main
struct AuthDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationView()
                .preferredColorScheme(.dark)
        }
    }
}

#Preview{
    AuthenticationView()
        .preferredColorScheme(.dark)
}
