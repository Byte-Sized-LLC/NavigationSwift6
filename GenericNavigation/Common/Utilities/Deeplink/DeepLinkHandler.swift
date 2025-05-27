//
//  DeepLinkHandler.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@Observable
final class DeepLinkManager: @unchecked Sendable {
    private let featureFlagManager: FeatureFlagService
    private let supportedDomains = ["example.com", "www.example.com"]
    
    init(featureFlagManager: FeatureFlagService = FeatureFlagService()) {
        self.featureFlagManager = featureFlagManager
    }
    
    func parse(url: URL) -> Result<NavigationRoute, DeepLinkError> {
        // Handle custom scheme (navigation://)
        if url.scheme == "navigation" {
            return parseCustomScheme(url: url)
        }
        
        // Handle universal links (https://)
        if url.scheme == "https" || url.scheme == "http" {
            return parseUniversalLink(url: url)
        }
        
        return .failure(.missingRouteComponents)
    }
    
    private func parseCustomScheme(url: URL) -> Result<NavigationRoute, DeepLinkError> {
        // Custom scheme format: navigation://[tab]/[route]?[params]
        // Examples:
        // navigation://home/detail?itemId=123
        // navigation://profile/followers?userId=456
        // navigation://search
        // navigation://settings/account
        
        guard let host = url.host else {
            return .failure(.missingRouteComponents)
        }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        switch host {
        case "home":
            return parseHomeDeepLink(pathComponents: pathComponents, url: url)
        case "profile":
            return parseProfileDeepLink(pathComponents: pathComponents, url: url)
        case "search":
            return parseSearchDeepLink(pathComponents: pathComponents, url: url)
        case "settings":
            return parseSettingsDeepLink(pathComponents: pathComponents, url: url)
        default:
            return .failure(.noNativeRouteFound)
        }
    }
    
    private func parseUniversalLink(url: URL) -> Result<NavigationRoute, DeepLinkError> {
        // Universal link format: https://example.com/[tab]/[route]?[params]
        guard let host = url.host, supportedDomains.contains(host) else {
            return .success(.weblink(WebRoute(url: url)))
        }
        
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        guard !pathComponents.isEmpty else {
            return .failure(.missingRouteComponents)
        }
        
        let tab = pathComponents[0]
        let remainingComponents = Array(pathComponents.dropFirst())
        
        switch tab {
        case "home":
            return parseHomeDeepLink(pathComponents: remainingComponents, url: url)
        case "profile":
            return parseProfileDeepLink(pathComponents: remainingComponents, url: url)
        case "search":
            return parseSearchDeepLink(pathComponents: remainingComponents, url: url)
        case "settings":
            return parseSettingsDeepLink(pathComponents: remainingComponents, url: url)
        default:
            return .success(.weblink(WebRoute(url: url)))
        }
    }
    
    private func parseHomeDeepLink(pathComponents: [String], url: URL) -> Result<NavigationRoute, DeepLinkError> {
        guard let firstComponent = pathComponents.first else {
            return .success(.rootTab(.home))
        }
        
        switch firstComponent {
        case "detail":
            if let itemId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "itemId" })?.value {
                return .success(.home(.detail(itemId: itemId), style: .push))
            }
        case "category":
            if let categoryId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "categoryId" })?.value {
                return .success(.home(.category(categoryId: categoryId), style: .push))
            }
        case "featured":
            return validateFeatureFlag(.featuredContent) {
                .success(.home(.featured, style: .push))
            }
        case "new":
            return .success(.home(.newItem, style: .sheet(detents: [.large])))
        default:
            break
        }
        
        return .success(.rootTab(.home))
    }
    
    private func parseProfileDeepLink(pathComponents: [String], url: URL) -> Result<NavigationRoute, DeepLinkError> {
        guard let firstComponent = pathComponents.first else {
            return .success(.rootTab(.profile))
        }
        
        switch firstComponent {
        case "edit":
            return .success(.profile(.editProfile, style: .sheet(detents: [.large])))
        case "followers":
            if let userId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "userId" })?.value {
                return .success(.profile(.followers(userId: userId), style: .push))
            }
        case "following":
            if let userId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "userId" })?.value {
                return .success(.profile(.following(userId: userId), style: .push))
            }
        case "achievements":
            return validateFeatureFlag(.achievements) {
                .success(.profile(.achievements, style: .push))
            }
        case "settings":
            return .success(.profile(.settings, style: .push))
        default:
            break
        }
        
        return .success(.rootTab(.profile))
    }
    
    private func parseSearchDeepLink(pathComponents: [String], url: URL) -> Result<NavigationRoute, DeepLinkError> {
        guard let firstComponent = pathComponents.first else {
            return .success(.rootTab(.search))
        }
        
        switch firstComponent {
        case "results":
            if let query = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?.first(where: { $0.name == "q" })?.value {
                return .success(.search(.results(query: query), style: .push))
            }
        case "advanced":
            return validateFeatureFlag(.advancedSearch) {
                .success(.search(.advanced, style: .push))
            }
        default:
            break
        }
        
        return .success(.rootTab(.search))
    }
    
    private func parseSettingsDeepLink(pathComponents: [String], url: URL) -> Result<NavigationRoute, DeepLinkError> {
        guard let firstComponent = pathComponents.first else {
            return .success(.rootTab(.settings))
        }
        
        switch firstComponent {
        case "account":
            return .success(.settings(.account, style: .push))
        case "privacy":
            return .success(.settings(.privacy, style: .push))
        case "notifications":
            return .success(.settings(.notifications, style: .push))
        case "appearance":
            return .success(.settings(.appearance, style: .push))
        case "premium":
            return validateFeatureFlag(.premiumFeatures) {
                .success(.settings(.premium, style: .sheet(detents: [.large])))
            }
        case "debug":
            return validateFeatureFlag(.debugMenu) {
                .success(.settings(.debug, style: .push))
            }
        default:
            break
        }
        
        return .success(.rootTab(.settings))
    }
    
    private func validateFeatureFlag(_ flag: FeatureFlag, route: () -> Result<NavigationRoute, DeepLinkError>) -> Result<NavigationRoute, DeepLinkError> {
        if featureFlagManager.isEnabled(flag) {
            return route()
        } else {
            return .failure(.featureFlagOff(flag: flag))
        }
    }
    
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        featureFlagManager.isEnabled(flag)
    }
}
