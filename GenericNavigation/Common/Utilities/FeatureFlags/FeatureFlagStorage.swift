//
//  FeatureFlagStorage.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

actor FeatureFlagStorage {
    @AppStorage("featureFlagOverrides") private var overrides: Data = Data()
    private var localOverrides: [String: Bool] = [:]
    
    func loadFlags() -> FeatureFlag {
        loadLocalOverrides()
        var flags = loadDefaultFlags()
        applyOverrides(&flags)
        return flags
    }
    
    private func loadDefaultFlags() -> FeatureFlag {
        #if DEBUG
        return .all
        #else
        return [.newOnboarding, .premiumFeatures]
        #endif
    }
    
    private func loadLocalOverrides() {
        if let decoded = try? JSONDecoder().decode([String: Bool].self, from: overrides) {
            localOverrides = decoded
        }
    }
    
    private func applyOverrides(_ flags: inout FeatureFlag) {
        for (flagName, isEnabled) in localOverrides {
            if let flag = flagFromName(flagName) {
                if isEnabled {
                    flags.insert(flag)
                } else {
                    flags.remove(flag)
                }
            }
        }
    }
    
    private func flagFromName(_ name: String) -> FeatureFlag? {
        switch name {
        case "New Onboarding": return .newOnboarding
        case "Advanced Search": return .advancedSearch
        case "Premium Features": return .premiumFeatures
        case "Achievements": return .achievements
        case "Featured Content": return .featuredContent
        case "Debug Menu": return .debugMenu
        default: return nil
        }
    }
    
    func saveOverride(flag: FeatureFlag, enabled: Bool) {
        localOverrides[flag.name] = enabled
        saveOverrides()
    }
    
    func clearOverrides() {
        localOverrides.removeAll()
        saveOverrides()
    }
    
    private func saveOverrides() {
        if let encoded = try? JSONEncoder().encode(localOverrides) {
            overrides = encoded
        }
    }
}
