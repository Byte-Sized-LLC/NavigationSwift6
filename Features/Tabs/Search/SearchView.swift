//
//  SearchView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @Environment(\.appRouter) private var appRouter
    @Environment(\.featureFlags) private var featureFlags
    
    var router: SearchRouter {
        appRouter.searchRouter()
    }
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText) {
                if !searchText.isEmpty {
                    Task { @MainActor in
                        router.push(.results(query: searchText))
                    }
                }
            }
            
            List {
                Section("Recent Searches") {
                    ForEach(["iPhone", "MacBook", "AirPods"], id: \.self) { recent in
                        Button(action: {
                            searchText = recent
                            Task { @MainActor in
                                router.push(.results(query: recent))
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
                                router.push(.advanced)
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
                        router.presentSheet(.filters(currentFilters: SearchFilters()))
                    }
                }
            }
        }
    }
}
