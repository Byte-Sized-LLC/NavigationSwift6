//
//  SearchSheet.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum SearchSheet: Identifiable, Sendable {
    case filters(currentFilters: SearchFilters)
    case saveSearch(query: String)
    
    var id: String {
        switch self {
        case .filters: return "search.sheet.filters"
        case .saveSearch: return "search.sheet.saveSearch"
        }
    }
}
