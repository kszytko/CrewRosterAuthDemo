//
//  AuthenticationView.swift
//  CabinCrewRoster
//
//  Created by Krzysiek on 2024-12-12.
//
import Lottie
import SwiftUI
import UIComponents
import AppInfo

// MARK: - AuthenticationView
public struct AuthenticationView: View {
    // MARK: Lifecycle
    public init() {}

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
                            RegisterView()
                        }
                        .buttonStyle(MainButtonStyle())

                        NavigationLink("Login") {
                            LoginView()
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

#Preview {
    AuthenticationView()
        .preferredColorScheme(.dark)
}
