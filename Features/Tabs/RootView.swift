//
//  ContentView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct RootView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.deepLinkHandler) private var deepLinkHandler
    @Environment(\.appDependencies) private var dependencies
    @Environment(\.featureFlags) private var featureFlags
    @State private var showDebugMenu = false
    
    var body: some View {
        Group {
            if appRouter.isOnboardingComplete {
                MainTabView()
            } else {
                OnboardingFlow()
            }
        }
        .onChange(of: deepLinkHandler.pendingDeepLink) { _, deepLink in
            Task {
                if let deepLink = deepLink {
                    await appRouter.handleDeepLink(deepLink, featureFlags: featureFlags)
                    await MainActor.run {
                        deepLinkHandler.pendingDeepLink = nil
                    }
                }
            }
        }
        .overlay(alignment: .topTrailing) {
            if featureFlags.isEnabled(.debugMenu) {
                debugButton
            }
        }
        .sheet(isPresented: $showDebugMenu) {
            DebugSettingsView()
        }
    }
    
    private var debugButton: some View {
        Button(action: { showDebugMenu = true }) {
            Image(systemName: "hammer.fill")
                .foregroundColor(.white)
                .padding(8)
                .background(Color.orange)
                .clipShape(Circle())
        }
        .padding()
    }
}

