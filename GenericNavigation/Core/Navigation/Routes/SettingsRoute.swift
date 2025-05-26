//
//  SettingsRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SettingsRoute: AppRoute {
    var id: Self { self }

    case account
    case privacy
    case notifications
    case appearance
    case debug
    case premium
    case exportData
    case deleteAccount
    
    var featureFlagKey: FeatureFlag? {
        return nil
    }
}
