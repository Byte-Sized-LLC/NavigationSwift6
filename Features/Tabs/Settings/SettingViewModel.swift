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
    private let navigationCoordinator: NavigationCoordinator
    private let featureFlagService: FeatureFlagService
    
    init(navigationCoordinator: NavigationCoordinator, featureFlagService: FeatureFlagService) {
        self.navigationCoordinator = navigationCoordinator
        self.featureFlagService = featureFlagService
    }
    
    func navigateToAccount() {
        navigationCoordinator.navigate(to: SettingsRoute.account, style: .push)
    }
    
    func navigateToPrivacy() {
        navigationCoordinator.navigate(to: SettingsRoute.privacy, style: .push)
    }
    
    func navigateToNotifications() {
        navigationCoordinator.navigate(to: SettingsRoute.notifications, style: .push)
    }
    
    func navigateToAppearance() {
        navigationCoordinator.navigate(to: SettingsRoute.appearance, style: .push)
    }
    
    func navigateToDebug() {
        navigationCoordinator.navigate(to: SettingsRoute.debug, style: .push)
    }
    
    func navigateToPremium() {
        navigationCoordinator.navigate(to: SettingsRoute.premium, style: .sheet(detents: [.large]))
    }
    
    func navigateToExportData() {
        navigationCoordinator.navigate(to: SettingsRoute.exportData, style: .sheet(detents: [.large]))
    }
    
    func navigateToDeleteAccount() {
        navigationCoordinator.navigate(to: SettingsRoute.deleteAccount, style: .sheet(detents: [.large]))
    }
    
    var isPremiumEnabled: Bool {
        featureFlagService.isEnabled(.premiumFeatures)
    }
}
