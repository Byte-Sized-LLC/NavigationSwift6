//
//  SettingsNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SettingsNavigationView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(FeatureFlagService.self) private var featureFlagService
    
    var body: some View {
        TabNavigationWrapper(
            tab: .settings,
            router: appRouter.settingsRouter,
            content: {
                let viewModel = SettingsViewModel(navigationManager: appRouter, featureFlagService: featureFlagService)
                SettingsView(viewModel: viewModel)
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
    }
    
    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .account:
            AccountSettingsView()
        case .privacy:
            PrivacySettingsView()
        case .notifications:
            NotificationSettingsView()
        case .appearance:
            AppearanceSettingsView()
        case .debug:
            DebugSettingsView()
        case .premium:
            PremiumView()
        case .exportData:
            ExportDataView()
        case .deleteAccount:
            DeleteAccountView()
        }
    }
}

