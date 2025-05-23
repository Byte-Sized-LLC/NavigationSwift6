//
//  SettingsRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SettingsRoute: AppRoute {
    case main
    case account
    case privacy
    case notifications
    case appearance
    case debug
    
    var id: String {
        switch self {
        case .main: return "settings.main"
        case .account: return "settings.account"
        case .privacy: return "settings.privacy"
        case .notifications: return "settings.notifications"
        case .appearance: return "settings.appearance"
        case .debug: return "settings.debug"
        }
    }
    
    var featureFlagKey: FeatureFlag? {
        return nil
    }
}
