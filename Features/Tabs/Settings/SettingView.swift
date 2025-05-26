//
//  SettingView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SettingsView: View {
    @State var viewModel: SettingsViewModel

    var body: some View {
        List {
            Section("Account") {
                Button(action: { viewModel.navigateToAccount() }) {
                    Label("Account Settings", systemImage: "person.circle")
                }
                
                Button(action: { viewModel.navigateToPrivacy() }) {
                    Label("Privacy", systemImage: "lock")
                }
                
                Button(action: { viewModel.navigateToNotifications() }) {
                    Label("Notifications", systemImage: "bell")
                }
            }
            
            Section("App") {
                Button(action: { viewModel.navigateToAppearance() }) {
                    Label("Appearance", systemImage: "paintbrush")
                }
                
                if viewModel.isPremiumEnabled {
                    Button(action: { viewModel.navigateToPremium() }) {
                        Label("Premium", systemImage: "crown")
                    }
                }
            }
            
            Section("Data") {
                Button(action: { viewModel.navigateToExportData() }) {
                    Label("Export Data", systemImage: "square.and.arrow.up")
                }
                
                Button(action: { viewModel.navigateToDeleteAccount() }) {
                    Label("Delete Account", systemImage: "trash")
                        .foregroundColor(.red)
                }
            }
            
            Section("Developer") {
                Button(action: { viewModel.navigateToDebug() }) {
                    Label("Debug Settings", systemImage: "hammer")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
