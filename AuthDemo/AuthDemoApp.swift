//
//  AuthDemoApp.swift
//  AuthDemo
//
//  Created by Krzysiek on 25/07/2025.
//

import Authentication
import AuthProvider
import SwiftUI

@main
struct AuthDemoApp: App {
    var body: some Scene {
        WindowGroup {
            AuthenticationView(authProvider: AuthProviderDummy(), authHandler: { _ in })
                .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    AuthenticationView(authProvider: AuthProviderDummy()) { state in
        debugPrint(state)
    }
    .preferredColorScheme(.dark)
}
