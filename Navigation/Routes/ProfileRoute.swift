//
//  ProfileRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//


import Foundation
enum ProfileRoute: AppRoute {
    case main(userId: String)
    case edit
    case settings
    case achievements
    case followers(userId: String)
    case following(userId: String)
    
    var id: String {
        switch self {
        case .main(let id): return "profile.main.\(id)"
        case .edit: return "profile.edit"
        case .settings: return "profile.settings"
        case .achievements: return "profile.achievements"
        case .followers(let id): return "profile.followers.\(id)"
        case .following(let id): return "profile.following.\(id)"
        }
    }
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .achievements: return .achievements
        default: return nil
        }
    }
}
