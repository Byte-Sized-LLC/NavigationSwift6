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
    @State private var appRouter = AppRouter()
    @State private var deepLinkHandler = DeepLinkManager()
    @State private var featureFlags = FeatureFlagService()
    @State private var dependencies = AppDependencies()
    @AppStorage("environment") private var environment: AppEnvironment = .production
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appRouter)
                .environment(deepLinkHandler)
                .environment(featureFlags)
                .environment(dependencies)
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
