//
//  RootTab.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum RootTab: Sendable, Identifiable, Hashable {
    var id: String { title }

    case home
    case search
    case profile
    case settings
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .profile: return "Profile"
        case .settings: return "Settings"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .profile: return "person.fill"
        case .settings: return "gear"
        }
    }
}
