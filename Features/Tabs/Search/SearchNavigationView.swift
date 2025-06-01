//
//  SearchNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchNavigationView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(FeatureFlagService.self) private var featureFlags
    
    var body: some View {
        GenericNavigationWrapper(
            router: appRouter.searchRouter,
            analyticsPrefix: "Search",
            content: {
                SearchView()
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
        .tabItem {
            Label(RootTab.search.title, systemImage: RootTab.search.icon)
        }
        .tag(RootTab.search)
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
