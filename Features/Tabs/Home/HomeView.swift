//
//  HomeView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @Environment(AppRouter.self) private var appRouter
    @Environment(FeatureFlagService.self) private var featureFlags
    
    var body: some View {
        Group {
            if viewModel.viewState.isLoading {
                ProgressView()
            } else if viewModel.viewState.items.isEmpty {
                EmptyStateView(
                    title: "No Items",
                    message: "Start by adding some items",
                    action: {
                        Task { @MainActor in
                            appRouter.homeRouter.navigate(to: .newItem, style: .sheet(detents: [.large]))
                        }
                    }
                )
            } else {
                List(viewModel.viewState.items) { item in
                    Button(action: {
                        Task { @MainActor in
                            appRouter.homeRouter.navigate(to: .detail(itemId: item.id), style: .push)
                        }
                    }) {
                        ItemRow(item: item)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task { @MainActor in
                                appRouter.homeRouter.showAlert(.error(title: "Error Title", message: "Error Message"))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
            }
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if featureFlags.isEnabled(.featuredContent) {
                    Button("Featured") {
                        Task { @MainActor in
                            appRouter.homeRouter.navigate(to: .featured, style: .push)
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("New Item") {
                        Task { @MainActor in
                            appRouter.homeRouter.navigate(to: .newItem, style: .sheet(detents: [.large]))
                        }
                    }
                    Button("Quick Add") {
                        Task { @MainActor in
                            appRouter.homeRouter.navigate(to: .quickAdd, style: .sheet(detents: [.large]))
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
