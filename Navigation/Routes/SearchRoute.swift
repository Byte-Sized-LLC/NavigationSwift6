//
//  SearchRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SearchRoute: AppRoute {
    case main
    case results(query: String)
    case filters
    case advanced
    
    var id: String {
        switch self {
        case .main: return "search.main"
        case .results(let query): return "search.results.\(query)"
        case .filters: return "search.filters"
        case .advanced: return "search.advanced"
        }
    }
    
    var featureFlagKey: FeatureFlag? {
        switch self {
        case .advanced: return .advancedSearch
        default: return nil
        }
    }
}
