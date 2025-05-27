//
//  CategoryView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct CategoryView: View {
    @State private var viewModel: CategoryViewModel
    
    init(categoryId: String, navigationManager: NavigationManager, userService: UserService) {
        self._viewModel = State(initialValue: CategoryViewModel(categoryId: categoryId, navigationManager: navigationManager, userService: userService))
    }
    
    var body: some View {
        VStack {
            Text("Category: \(viewModel.categoryId)")
                .navigationTitle("Category")
            
            Text("User: \(viewModel.fetchedUser?.email ?? "-")")
            
            Button("Fetch User") {
                viewModel.fetchUser()
            }
            .padding()
            
            
            Button("Go to Settings") {
                Task { @MainActor in
                    viewModel.navigateToSettings()
                }
            }
            .padding()
            
            Button("Go to Featured") {
                Task { @MainActor in
                    viewModel.navigateToFeatured()
                }
            }
            .padding()
            
            Button("Go to Account Settings") {
                Task { @MainActor in
                    viewModel.navigateToAccountSettings()
                }
            }
            .padding()
        }
    }
}
