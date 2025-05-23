//
//  ServiceFilters.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct SearchFilters: Sendable {
    var categories: Set<String> = []
    var priceRange: ClosedRange<Double> = 0...100
    var sortBy: SortOption = .relevance
    
    enum SortOption: Sendable {
        case relevance, priceAsc, priceDesc, newest
    }
}
