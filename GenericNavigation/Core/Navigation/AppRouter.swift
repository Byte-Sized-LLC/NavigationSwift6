//
//  AppRouter.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

@Observable
final class AppRouter: @unchecked Sendable {
    private(set) var homeRouter = HomeRouter()
    private(set) var profileRouter = ProfileRouter()
    private(set) var searchRouter = SearchRouter()
    private(set) var settingsRouter = SettingsRouter()
    
    var selectedTab: RootTab = .home
    
    private let deepLinkManager: DeepLinkManager
    private let featureFlagManager: FeatureFlagService

    init() {
        self.deepLinkManager = DeepLinkManager()
        self.featureFlagManager = FeatureFlagService()
    }
    
    /// Navigate at the "App level" to a specific route (which includes the tab).
    /// ResetRoot - Pops back to root before pushing. Mainy used for deeplinks, to not keep stacking views when called multiple times.
    @MainActor
    func handle(_ action: NavigationRoute, resetRoot: Bool = false) {
        if resetRoot {
            resetAllNavigatorsToRoot()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.performNavigation(for: action)
            }
        } else {
            performNavigation(for: action)
        }
    }
    
    @MainActor
    private func performNavigation(for action: NavigationRoute) {
        switch action {
        case .rootTab(let tab):
            selectedTab = tab
            
        case .home(let homeRoute, let style):
            selectedTab = .home
            homeRouter.navigate(to: homeRoute, style: style)
            
        case .profile(let profileRoute, let style):
            selectedTab = .profile
            profileRouter.navigate(to: profileRoute, style: style)

        case .search(let searchRoute, let style):
            selectedTab = .search
            searchRouter.navigate(to: searchRoute, style: style)

        case .settings(let settingsRoute, let style):
            selectedTab = .settings
            settingsRouter.navigate(to: settingsRoute, style: style)

        case .deeplink(let string):
            guard let url = URL(string: string) else { return }
            handleDeepLink(url: url)
        case .weblink(let route):
            switch selectedTab {
            case .home:
                homeRouter.navigateToWebView(route)
            case .profile:
                profileRouter.navigateToWebView(route)
            case .search:
                searchRouter.navigateToWebView(route)
            case .settings:
                settingsRouter.navigateToWebView(route)
            }
        }
    }
    
    @MainActor
    func handleDeepLink(url: URL) {
        let result = deepLinkManager.parse(url: url)
        switch result {
        case .success(let route):
            handle(route, resetRoot: true)
        case .failure(let error):
            print("Error with deeplink: \(error.description)")
        }
    }
    
    @MainActor
    private func resetAllNavigatorsToRoot() {
        homeRouter.popToRoot()
        profileRouter.popToRoot()
        searchRouter.popToRoot()
        settingsRouter.popToRoot()
    }
}
