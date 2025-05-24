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
        @Bindable var routerBinding = appRouter.searchRouter
        
        NavigationStack(path: $routerBinding.path) {
            SearchView()
                .navigationDestination(for: SearchRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $routerBinding.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: SearchRoute) -> some View {
        switch route {
        case .main:
            SearchView()
        case .results(let query):
            SearchResultsView(query: query)
        case .filters:
            SearchFiltersView()
        case .advanced:
            if featureFlags.isEnabled(.advancedSearch) {
                AdvancedSearchView()
            } else {
                Text("Advanced Search is not available")
            }
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: SearchSheet) -> some View {
        switch sheet {
        case .filters(let currentFilters):
            SearchFiltersSheet(filters: currentFilters)
                .presentationDetents([.medium])
        case .saveSearch(let query):
            SaveSearchView(query: query)
                .presentationDetents([.height(300)])
        }
    }
}
