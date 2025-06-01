//
//  GenericNavigationApp.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI
import Observation

@main
struct GenericNavigationApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    @State private var appRouter: AppRouter
    @State private var deepLinkHandler: DeepLinkManager
    @State private var featureFlags: FeatureFlagService
    @State private var dependencies: AppDependencies
    @State private var onboardingStateManager: OnboardingStateManager
    @AppStorage("environment") private var environment: AppEnvironment = .production
    
    init() {
        // Initialize dependencies first
        let deps = AppDependencies()
        _dependencies = State(initialValue: deps)
        
        // Initialize other services
        _appRouter = State(initialValue: AppRouter())
        _deepLinkHandler = State(initialValue: DeepLinkManager())
        _featureFlags = State(initialValue: FeatureFlagService())
        
        // Initialize onboarding state manager with persistence service
        _onboardingStateManager = State(initialValue: OnboardingStateManager())
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appRouter)
                .environment(deepLinkHandler)
                .environment(featureFlags)
                .environment(dependencies)
                .environment(onboardingStateManager)
                .environment(\.appEnvironment, environment)
                .onOpenURL { url in
                    appRouter.handleDeepLink(url: url)
                }
                .onChange(of: scenePhase) { _, newPhase in
                    Task {
                        await handleScenePhase(newPhase)
                    }
                }
        }
    }
    
    private func handleScenePhase(_ phase: ScenePhase) async {
        await dependencies.analyticsService.track(.appLifecycle(phase))
    }
}
