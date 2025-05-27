//
//  SettingViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    private let navigationManager: NavigationManager
    private let featureFlagService: FeatureFlagService
    
    init(navigationManager: NavigationManager, featureFlagService: FeatureFlagService) {
        self.navigationManager = navigationManager
        self.featureFlagService = featureFlagService
    }
    
    func navigateToAccount() {
        navigationManager.navigate(to: SettingsRoute.account, style: .push)
    }
    
    func navigateToPrivacy() {
        navigationManager.navigate(to: SettingsRoute.privacy, style: .push)
    }
    
    func navigateToNotifications() {
        navigationManager.navigate(to: SettingsRoute.notifications, style: .push)
    }
    
    func navigateToAppearance() {
        navigationManager.navigate(to: SettingsRoute.appearance, style: .push)
    }
    
    func navigateToDebug() {
        navigationManager.navigate(to: SettingsRoute.debug, style: .push)
    }
    
    func navigateToPremium() {
        navigationManager.navigate(to: SettingsRoute.premium, style: .sheet(detents: [.large]))
    }
    
    func navigateToExportData() {
        navigationManager.navigate(to: SettingsRoute.exportData, style: .sheet(detents: [.large]))
    }
    
    func navigateToDeleteAccount() {
        navigationManager.navigate(to: SettingsRoute.deleteAccount, style: .sheet(detents: [.large]))
    }
    
    var isPremiumEnabled: Bool {
        featureFlagService.isEnabled(.premiumFeatures)
    }
}
