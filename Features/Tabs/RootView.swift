//
//  RootView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct RootView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    @Environment(FeatureFlagService.self) private var featureFlags
    @Environment(OnboardingStateManager.self) private var onboardingStateManager
    @State private var showDebugMenu = false
    
    
    var body: some View {
        Group {
            // Check onboarding state from the state manager
            if onboardingStateManager.onboardingComplete {
                MainTabView()
            } else {
                OnboardingFlow()
                    .environment(appRouter.onboardingRouter)
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

#Preview {
    RootView()
        .environment(AppRouter())
        .environment(AppDependencies())
        .environment(FeatureFlagService())
        .environment(OnboardingStateManager())
}
