//
//  AuthenticationView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-12.
//
import SwiftUI

import AppInfo
import AuthProvider
import Lottie
import UIComponents

// MARK: - AuthenticationView
public struct AuthenticationView: View {
    // MARK: Properties
    let authProvider: AuthProviderProtocol
    let authHandler: (AuthState) -> Void

    // MARK: Lifecycle
    public init(authProvider: any AuthProviderProtocol, authHandler: @escaping (AuthState) -> Void) {
        self.authProvider = authProvider
        self.authHandler = authHandler
    }

    // MARK: Content Properties

    // MARK: Content
    public var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    LottieView(animation: .named("AirplaneAnimation"))
                        .looping()
                        .resizable()

                    titleView

                    VStack {
                        NavigationLink("Create account") {
                            RegisterView(authProvider: authProvider, authHandler: authHandler)
                        }
                        .buttonStyle(MainButtonStyle())

                        NavigationLink("Login") {
                            LoginView(authProvider: authProvider, authHandler: authHandler)
                        }
                        .buttonStyle(LoginButtonStyle())
                    }
                    .padding()
                }
                .applyScreenBackground()
            }
            .navigationBarTitleDisplayMode(.inline)
            .appInfoInset()
        }
        .tint(.white)
    }

    var titleView: some View {
        VStack(alignment: .center) {
            Text("CREW ROSTER")
                .foregroundStyle(.blue)
                .font(.system(size: 50, weight: .light))
                .padding(.bottom)

            Text("All your flight essentials.")
                .multilineTextAlignment(.center)
                .font(.title.bold())

            Text("In one place.")
                .font(.title2)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
