//
//  HomeView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct HomeView: View {
    @Bindable var viewModel: HomeViewModel
    @Environment(\.appRouter) private var appRouter
    @Environment(\.featureFlags) private var featureFlags
    
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
                            appRouter.homeRouter.presentSheet(.newItem)
                        }
                    }
                )
            } else {
                List(viewModel.viewState.items) { item in
                    Button(action: {
                        Task { @MainActor in
                            appRouter.homeRouter.push(.detail(itemId: item.id))
                        }
                    }) {
                        ItemRow(item: item)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            Task { @MainActor in
                                appRouter.homeRouter.showAlert(HomeAlert(type: .deleteItem(itemId: item.id)))
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
                            appRouter.homeRouter.push(.featured)
                        }
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("New Item") {
                        Task { @MainActor in
                            appRouter.homeRouter.presentSheet(.newItem)
                        }
                    }
                    Button("Quick Add") {
                        Task { @MainActor in
                            appRouter.homeRouter.presentSheet(.quickAdd)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
