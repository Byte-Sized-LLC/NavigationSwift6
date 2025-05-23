//
//  SettingView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.featureFlags) private var featureFlags
    
    var router: SettingsRouter {
        appRouter.settingsRouter()
    }
    
    var body: some View {
        List {
            Section("Account") {
                NavigationLink(value: SettingsRoute.account) {
                    Label("Account Settings", systemImage: "person.circle")
                }
                
                NavigationLink(value: SettingsRoute.privacy) {
                    Label("Privacy", systemImage: "lock")
                }
                
                NavigationLink(value: SettingsRoute.notifications) {
                    Label("Notifications", systemImage: "bell")
                }
            }
            
            Section("App") {
                NavigationLink(value: SettingsRoute.appearance) {
                    Label("Appearance", systemImage: "paintbrush")
                }
                
                if featureFlags.isEnabled(.premiumFeatures) {
                    Button(action: {
                        Task { @MainActor in
                            router.presentSheet(.premium)
                        }
                    }) {
                        Label("Premium", systemImage: "crown")
                    }
                }
            }
            
            Section("Data") {
                Button(action: {
                    Task { @MainActor in
                        router.presentSheet(.exportData)
                    }
                }) {
                    Label("Export Data", systemImage: "square.and.arrow.up")
                }
                
                Button(action: {
                    Task { @MainActor in
                        router.presentSheet(.deleteAccount)
                    }
                }) {
                    Label("Delete Account", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
            
            Section("Developer") {
                NavigationLink(value: SettingsRoute.debug) {
                    Label("Debug Settings", systemImage: "hammer")
                }
            }

        }
        .navigationTitle("Settings")
    }
}
