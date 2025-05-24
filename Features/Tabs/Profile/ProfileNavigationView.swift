//
//  ProfileNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ProfileNavigationView: View {
    @Environment(\.appRouter) private var appRouter
    @Environment(\.appDependencies) private var dependencies
    @State private var viewModel: ProfileViewModel
    
    init() {
        let dependencies = AppDependencies()
        let store = ProfileStore(dependencies: dependencies)
        _viewModel = State(initialValue: ProfileViewModel(store: store))
    }
    
    var body: some View {
        @Bindable var routerBinding = appRouter.profileRouter
        
        NavigationStack(path: $routerBinding.path) {
            ProfileView(viewModel: viewModel, userId: "current")
                .navigationDestination(for: ProfileRoute.self) { route in
                    destinationView(for: route)
                }
        }
        .sheet(item: $routerBinding.presentedSheet) { sheet in
            sheetView(for: sheet)
        }
        .alert(item: $routerBinding.alertItem) { alert in
            alertView(for: alert)
        }
        .onAppear {
            viewModel.loadUser()
        }
    }
    
    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .main(let userId):
            ProfileView(viewModel: viewModel, userId: userId)
        case .edit:
            EditProfileView(viewModel: viewModel)
        case .settings:
            ProfileSettingsView()
        case .achievements:
            AchievementsView()
        case .followers(let userId):
            FollowersView(userId: userId)
        case .following(let userId):
            FollowingView(userId: userId)
        }
    }
    
    @ViewBuilder
    private func sheetView(for sheet: ProfileSheet) -> some View {
        switch sheet {
        case .editProfile:
            EditProfileSheet(viewModel: viewModel)
                .presentationDetents([.large])
        case .changePhoto:
            ChangePhotoView()
                .presentationDetents([.medium])
        case .shareProfile:
            ShareProfileView()
                .presentationDetents([.medium])
        }
    }
    
    private func alertView(for alert: ProfileAlert) -> Alert {
        switch alert.type {
        case .logoutConfirmation:
            return Alert(
                title: Text("Log Out"),
                message: Text("Are you sure you want to log out?"),
                primaryButton: .destructive(Text("Log Out")) {
                    // Handle logout
                },
                secondaryButton: .cancel()
            )
        case .unsavedChanges:
            return Alert(
                title: Text("Unsaved Changes"),
                message: Text("You have unsaved changes. What would you like to do?"),
                primaryButton: .default(Text("Save")) {
                    // Save changes
                },
                secondaryButton: .destructive(Text("Discard")) {
                    // Discard changes
                }
            )
        }
    }
}

