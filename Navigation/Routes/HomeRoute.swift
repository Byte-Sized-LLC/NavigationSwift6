//
//  HomeRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum HomeRoute: AppRoute {
    var id: Self { self }

    case list
    case detail(itemId: String)
    case category(categoryId: String)
    case featured
    case newItem
    case share(itemId: String)
    case quickAdd
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .featured: return .featuredContent
        default: return nil
        }
    }
}
