//
//  AppEnvironment.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

enum AppEnvironment: String, CaseIterable, Sendable {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development: return "https://dev.api.example.com"
        case .staging: return "https://staging.api.example.com"
        case .production: return "https://api.example.com"
        }
    }
}

// ✅ Use @Environment(Type.self) for:
// - @Observable classes
// - Reference types that need single instance
// - Shared state objects
// - Services and managers

// ✅ Use @Environment(\.keyPath) for:
// - Value types (structs, enums)
// - SwiftUI built-in values
// - Simple configuration values
// - Immutable settings

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .production
}

private struct AnalyticsServiceKey: EnvironmentKey {
    static let defaultValue = AnalyticsService()
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
    
    var analyticsService: AnalyticsService {
        get { self[AnalyticsServiceKey.self] }
        set { self[AnalyticsServiceKey.self] = newValue }
    }
}
