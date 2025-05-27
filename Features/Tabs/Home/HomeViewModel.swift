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
    private var stateObservationTask: Task<Void, Never>?
    
    struct ViewState {
        var items: [Item] = []
        var isLoading = false
        var error: String?
    }
    
    required init(store: HomeStore) {
        self.store = store
        startObserving()
    }
    
//    deinit {
//        stateObservationTask?.cancel()
//    }
    
    private func startObserving() {
        stateObservationTask = Task { [weak self] in
            guard let self else { return }
            
            for await state in await store.stateStream {
                guard !Task.isCancelled else { break }
                
                self.viewState.items = state.items
                self.viewState.isLoading = state.isLoading
                self.viewState.error = state.error
            }
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
