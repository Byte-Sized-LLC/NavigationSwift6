//
//  FeatureFlag.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct FeatureFlag: OptionSet, Sendable {
    let rawValue: Int
    
    static let newOnboarding = FeatureFlag(rawValue: 1 << 0)
    static let advancedSearch = FeatureFlag(rawValue: 1 << 1)
    static let premiumFeatures = FeatureFlag(rawValue: 1 << 2)
    static let achievements = FeatureFlag(rawValue: 1 << 3)
    static let featuredContent = FeatureFlag(rawValue: 1 << 4)
    static let debugMenu = FeatureFlag(rawValue: 1 << 5)
    
    static let all: FeatureFlag = [.newOnboarding, .advancedSearch, .premiumFeatures, .achievements, .featuredContent, .debugMenu]
    
    var name: String {
        switch self {
        case .newOnboarding: return "New Onboarding"
        case .advancedSearch: return "Advanced Search"
        case .premiumFeatures: return "Premium Features"
        case .achievements: return "Achievements"
        case .featuredContent: return "Featured Content"
        case .debugMenu: return "Debug Menu"
        default: return "Unknown"
        }
    }
}
