//
//  NavigationRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import Foundation

enum NavigationRoute: Sendable, Equatable {
    case home(HomeRoute, style: NavigationStyle)
    case profile(ProfileRoute, style: NavigationStyle)
    case search(SearchRoute, style: NavigationStyle)
    case settings(SettingsRoute, style: NavigationStyle)
    case rootTab(RootTab)
    case deeplink(String)
    case weblink(WebRoute)
}
