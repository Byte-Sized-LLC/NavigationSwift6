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
    private let supportedDomains = ["jetblue.com", "www.jetblue.com"]
    
    init(featureFlagManager: FeatureFlagService = FeatureFlagService()) {
        self.featureFlagManager = featureFlagManager
    }
    
    func parse(url: URL) -> Result<NavigationRoute, DeepLinkError> {
        /// If this is an external HTTPS link (not one of our known deep‑link domains), treat it as a website link.
        if isExternalWebLink(url) {
            return .success(.weblink(WebRoute(url: url)))
        }
        
        let components = extractRouteComponents(url: url)
        guard !components.isEmpty else {
            return .failure(.missingRouteComponents)
        }
        
        /// Try to parse a native route from the URL.
        guard let nativeRoute = parseNativeRoute(from: components, url: url) else {
            /// For universal links, fall back to a webview; otherwise, report error.
            return isUniversalLink(url) ? .success(.weblink(WebRoute(url: url))) : .failure(.noNativeRouteFound)
        }
        
        /// Validate the native route (e.g. against feature flags).
        return validateRoute(nativeRoute, for: url)
    }
    
    /// Returns true if the URL (or its assumed HTTPS form) uses HTTPS and its host is not in our supported domains.
    private func isExternalWebLink(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased() ?? "https"
        let host = extractHost(from: url)
        guard scheme == "https", let host = host else { return false }
        return !supportedDomains.contains(host)
    }
    
    /// Returns true if the URL (or its assumed HTTPS form) uses HTTPS and its host is in our supported domains.
    private func isUniversalLink(_ url: URL) -> Bool {
        let scheme = url.scheme?.lowercased() ?? "https"
        let host = extractHost(from: url)
        guard scheme == "https", let host = host else { return false }
        return supportedDomains.contains(host)
    }
    
    /// If the URL’s host property is nil, try to extract it from the absolute string.
    private func extractHost(from url: URL) -> String? {
        if let host = url.host?.lowercased() {
            return host
        }
        // Fallback: split the absolute string and check the first component.
        let comps = url.absoluteString.components(separatedBy: "/").filter { !$0.isEmpty }
        if let first = comps.first, first.contains(".") {
            return first.lowercased()
        }
        return nil
    }
    
    /// Returns an array of normalized route components.
    /// - For HTTPS links (or missing scheme), returns the path components (e.g. ["mytrips", "tripdetail"]).
    /// - For custom-scheme links, includes the host as the first component.
    private func extractRouteComponents(url: URL) -> [String] {
        if let scheme = url.scheme?.lowercased(), scheme == "https" {
            return url.pathComponents.filter { $0 != "/" }.map { $0.lowercased() }
        } else if url.scheme == nil {
            let absolute = url.absoluteString
            let comps = absolute.components(separatedBy: "/").filter { !$0.isEmpty }
            if let first = comps.first, first.contains(".") {
                return Array(comps.dropFirst()).map { $0.lowercased() }
            } else {
                return comps.map { $0.lowercased() }
            }
        } else {
            var components: [String] = []
            if let host = url.host?.lowercased() {
                components.append(host)
            }
            components.append(contentsOf: url.pathComponents.filter { $0 != "/" }.map { $0.lowercased() })
            return components
        }
    }
    
    /// Extracts the first query parameter's value (if any).
    private func extractQueryParam(url: URL) -> String {
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
        return queryItems?.first?.value ?? ""
    }
    
    private func parseNativeRoute(from components: [String], url: URL) -> NavigationRoute? {
        // The first component identifies the tab/section.
        let identifier = components[0]
        switch identifier {
        case "home":
            return parseHomeRoute(from: components, url: url)
        case "profile":
            return parseProfileRoute(from: components, url: url)
        case "search":
            return .rootTab(.search)
        case "settings":
            return .rootTab(.settings)
        default:
            return nil
        }
    }
    
    private func parseHomeRoute(from components: [String], url: URL) -> NavigationRoute {
        if components.count >= 2, components[1] == "detail" {
            let param = extractQueryParam(url: url)
            return .home(.detail(itemId: param), style: .push)
        }
        return .rootTab(.home)
    }
    
    private func parseProfileRoute(from components: [String], url: URL) -> NavigationRoute {
        if components.count >= 2 {
            let second = components[1]
            switch second {
            case "followers":
                let userId = components[2]
                return .profile(.followers(userId: userId), style: .push)
            default:
                return .rootTab(.profile)
            }
        }
        return .rootTab(.profile)
    }
    
    private func validateRoute(_ route: NavigationRoute, for url: URL) -> Result<NavigationRoute, DeepLinkError> {
        var requiredFlag: FeatureFlag?
        switch route {
        case .home(let homeRoute, _):
            requiredFlag = homeRoute.featureFlagKey
        case .profile(let profileRoute, _):
            requiredFlag = profileRoute.featureFlagKey
        case .search(let searchRoute, _):
            requiredFlag = searchRoute.featureFlagKey
        case .settings(let settingsRoute, _):
            requiredFlag = settingsRoute.featureFlagKey
        default:
            requiredFlag = nil
        }
        
        if let flag = requiredFlag, !featureFlagManager.isEnabled(flag) {
            if isUniversalLink(url) {
                /// Feature Flag is off but since this is a link, navigate to web version
                return .success(.weblink(WebRoute(url: url)))
            } else {
                /// Feature Flag is off and not a link to nowhere to navigate
                return isUniversalLink(url) ? .success(.weblink(WebRoute(url: url))) : .failure(.featureFlagOff(flag: flag))
            }
        }
        
        return .success(route)
    }
    
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        featureFlagManager.isEnabled(flag)
    }
}

