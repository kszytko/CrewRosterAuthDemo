//
//  AppInfo.swift
//  modules
//
//  Created by Krzysiek on 2025-01-27.
//
import SwiftUI

// MARK: - AppInfo
public struct AppInfo: View {
    // MARK: Properties
    let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    let buildVersion = Bundle.main.infoDictionary!["CFBundleVersion"] as! String

    // MARK: Computed Properties
    var mode: String {
        #if PRODUCTION
            "Prod"
        #else
            "Dev"
        #endif
    }

    // MARK: Lifecycle
    public init() {}

    // MARK: Content Properties

    // MARK: Content
    public var body: some View {
        VStack {
            Text("\(mode) v\(appVersion) \(buildVersion)")
            Text("Ⓒ 2025 CrewRoster. All rights reserved.")
        }
        .font(.caption2)
        .foregroundStyle(.tertiary)
    }
}

public extension View {
    func appInfoInset() -> some View {
        safeAreaInset(edge: .bottom) {
            AppInfo()
        }
    }
}
