//
//  TabItem.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum TabItem: Int, CaseIterable, Sendable {
    case home = 0
    case search = 1
    case profile = 2
    case settings = 3
    
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
