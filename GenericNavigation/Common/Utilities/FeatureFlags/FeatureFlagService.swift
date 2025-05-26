//
//  FeatureFlagService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

#warning("make me a protocol")
@Observable
final class FeatureFlagService: @unchecked Sendable {
    var enabledFlags: FeatureFlag = []
    @ObservationIgnored private let storage = FeatureFlagStorage()
    
    init() {
        Task {
            await loadFlags()
        }
    }
    
    private func loadFlags() async {
        enabledFlags = await storage.loadFlags()
    }
    
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        enabledFlags.contains(flag)
    }
    
    func setOverride(_ flag: FeatureFlag, enabled: Bool) async {
        if enabled {
            enabledFlags.insert(flag)
        } else {
            enabledFlags.remove(flag)
        }
        await storage.saveOverride(flag: flag, enabled: enabled)
    }
    
    func clearOverrides() async {
        await storage.clearOverrides()
        await loadFlags()
    }
}
