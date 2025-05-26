//
//  ProfileRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//


import Foundation

enum ProfileRoute: AppRoute {
    var id: Self { self }

    case edit
    case settings
    case achievements
    case followers(userId: String)
    case following(userId: String)
    case editProfile
    case changePhoto
    case shareProfile
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .achievements: return .achievements
        default: return nil
        }
    }
}
