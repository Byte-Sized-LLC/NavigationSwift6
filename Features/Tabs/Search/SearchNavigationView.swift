//
//  SearchNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchNavigationView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.featureFlags) private var featureFlags
    
    var body: some View {
        TabNavigationWrapper(
            tab: .search,
            router: appRouter.searchRouter,
            content: {
                SearchView()
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
    }
    
    @ViewBuilder
    private func destinationView(for route: SearchRoute) -> some View {
        switch route {
        case .results(let query):
            SearchResultsView(query: query)
        case .filters(let currentFilters):
            SearchFiltersSheet(filters: currentFilters)
        case .advanced:
            if featureFlags.isEnabled(.advancedSearch) {
                AdvancedSearchView()
            } else {
                Text("Advanced Search is not available")
            }
        case .saveSearch(query: let query):
            SaveSearchView(query: query)
        }
    }
}
