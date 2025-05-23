//
//  HomeRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum HomeRoute: AppRoute {
    case list
    case detail(itemId: String)
    case category(categoryId: String)
    case featured
    
    var id: String {
        switch self {
        case .list: return "home.list"
        case .detail(let id): return "home.detail.\(id)"
        case .category(let id): return "home.category.\(id)"
        case .featured: return "home.featured"
        }
    }
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .featured: return .featuredContent
        default: return nil
        }
    }
}
