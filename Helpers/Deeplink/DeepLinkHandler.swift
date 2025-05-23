//
//  DeepLinkHandler.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@Observable
final class DeepLinkHandler: @unchecked Sendable {
    var pendingDeepLink: DeepLink?
    
    @MainActor
    func handle(_ url: URL, featureFlags: FeatureFlagService) async {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
              let host = components.host else { return }
        
        switch host {
        case "profile":
            if let userId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                pendingDeepLink = .profile(userId: userId)
            }
        case "item":
            if let itemId = components.queryItems?.first(where: { $0.name == "id" })?.value {
                pendingDeepLink = .item(itemId: itemId)
            }
        case "search":
            let query = components.queryItems?.first(where: { $0.name == "q" })?.value
            pendingDeepLink = .search(query: query)
        case "settings":
            pendingDeepLink = .settings
        default:
            break
        }
    }
}
