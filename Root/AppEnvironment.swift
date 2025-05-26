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

private struct AppEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppEnvironment = .production
}

private struct AppRouterKey: EnvironmentKey {
    static let defaultValue = AppRouter()
}

private struct FeatureFlagsKey: EnvironmentKey {
    static let defaultValue = FeatureFlagService()
}

private struct AnalyticsServiceKey: EnvironmentKey {
    static let defaultValue = AnalyticsService()
}

private struct AppDependencyKey: EnvironmentKey {
    static let defaultValue = AppDependencies()
}

private struct DeepLinkHandlerKey: EnvironmentKey {
    static let defaultValue = DeepLinkManager()
}

extension EnvironmentValues {
    var appEnvironment: AppEnvironment {
        get { self[AppEnvironmentKey.self] }
        set { self[AppEnvironmentKey.self] = newValue }
    }
    
    var appRouter: AppRouter {
        get { self[AppRouterKey.self] }
        set { self[AppRouterKey.self] = newValue }
    }
    
    var featureFlags: FeatureFlagService {
        get { self[FeatureFlagsKey.self] }
        set { self[FeatureFlagsKey.self] = newValue }
    }
    
    var analyticsService: AnalyticsService {
        get { self[AnalyticsServiceKey.self] }
        set { self[AnalyticsServiceKey.self] = newValue }
    }
    
    var appDependencies: AppDependencies {
        get { self[AppDependencyKey.self] }
        set { self[AppDependencyKey.self] = newValue }
    }
    
    var deepLinkHandler: DeepLinkManager {
        get { self[DeepLinkHandlerKey.self] }
        set { self[DeepLinkHandlerKey.self] = newValue }
    }
}
