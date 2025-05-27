//
//  ProfileNavigationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ProfileNavigationView: View {
    @Environment(AppRouter.self) private var appRouter
    @Environment(AppDependencies.self) private var dependencies
    
    var body: some View {
        TabNavigationWrapper(
            tab: .profile,
            router: appRouter.profileRouter,
            content: {
                let store = ProfileStore(dependencies: dependencies)
                let viewModel = ProfileViewModel(store: store, navigationCoordinator: appRouter)
                ProfileView(viewModel: viewModel, userId: "current")
            },
            destinationBuilder: { route in
                destinationView(for: route)
            }
        )
    }
    
    @ViewBuilder
    private func destinationView(for route: ProfileRoute) -> some View {
        switch route {
        case .edit:
            EditProfileView()
        case .settings:
            ProfileSettingsView()
        case .achievements:
            AchievementsView()
        case .followers(let userId):
            FollowersView(userId: userId)
        case .following(let userId):
            FollowingView(userId: userId)
        case .editProfile:
            EditProfileSheet()
        case .changePhoto:
            ChangePhotoView()
        case .shareProfile:
            ShareProfileView()
        }
    }
}

