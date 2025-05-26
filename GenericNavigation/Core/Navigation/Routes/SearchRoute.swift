//
//  SearchRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SearchRoute: AppRoute {
    var id: Self { self }

    case results(query: String)
    case advanced
    case filters(currentFilters: SearchFilters)
    case saveSearch(query: String)
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .advanced: return .advancedSearch
        default: return nil
        }
    }
}
