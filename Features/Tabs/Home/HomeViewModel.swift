//
//  HomeViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
@Observable
final class HomeViewModel: ViewModel {
    let store: HomeStore
    private(set) var viewState = ViewState()
    
    struct ViewState {
        var items: [Item] = []
        var isLoading = false
        var error: String?
    }
    
    required init(store: HomeStore) {
        self.store = store
        Task {
            await observeState()
        }
    }
    
    private func observeState() async {
        for await _ in Timer.publish(every: 0.1, on: .main, in: .common).autoconnect().values {
            let state = await store.getState()
            viewState.items = state.items
            viewState.isLoading = state.isLoading
            viewState.error = state.error
        }
    }
    
    func loadItems() {
        Task {
            await store.dispatch(.loadItems)
        }
    }
    
    func deleteItem(_ item: Item) {
        Task {
            await store.dispatch(.deleteItem(item.id))
        }
    }
}
