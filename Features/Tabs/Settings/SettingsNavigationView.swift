//
//  SettingsNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SettingsNavigationView: View {
    @Environment(\.appRouter) private var appRouter
    
    var router: SettingsRouter {
        appRouter.settingsRouter()
    }
    
    var body: some View {
        @Bindable var routerBinding = router
        
        NavigationStack(path: $routerBinding.path) {
            SettingsView()
                .navigationDestination(for: SettingsRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $routerBinding.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: SettingsRoute) -> some View {
        switch route {
        case .main:
            SettingsView()
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
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: SettingsSheet) -> some View {
        switch sheet {
        case .premium:
            PremiumView()
                .presentationDetents([.large])
        case .exportData:
            ExportDataView()
                .presentationDetents([.medium])
        case .deleteAccount:
            DeleteAccountView()
                .presentationDetents([.medium])
        }
    }
}

