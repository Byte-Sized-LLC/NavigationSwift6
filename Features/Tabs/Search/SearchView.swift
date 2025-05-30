//
//  SearchView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(AppRouter.self) private var appRouter
    @Environment(FeatureFlagService.self) private var featureFlags

    var body: some View {
        VStack {
            SearchBar(text: $searchText) {
                if !searchText.isEmpty {
                    Task { @MainActor in
                        appRouter.searchRouter.navigate(to: .results(query: searchText), style: .push)
                    }
                }
            }
            
            List {
                Section("Recent Searches") {
                    ForEach(["iPhone", "MacBook", "AirPods"], id: \.self) { recent in
                        Button(action: {
                            searchText = recent
                            Task { @MainActor in
                                appRouter.searchRouter.navigate(to: .results(query: recent), style: .push)
                            }
                        }) {
                            HStack {
                                Image(systemName: "clock")
                                Text(recent)
                            }
                        }
                    }
                }
                
                if featureFlags.isEnabled(.advancedSearch) {
                    Section {
                        Button("Advanced Search") {
                            Task { @MainActor in
                                appRouter.searchRouter.navigate(to: .advanced, style: .push)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Search")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Filters") {
                    Task { @MainActor in
                        appRouter.searchRouter.navigate(to: .filters(currentFilters: SearchFilters()), style: .sheet(detents: [.large]))
                    }
                }
            }
        }
    }
}
