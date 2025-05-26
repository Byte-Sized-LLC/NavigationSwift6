//
//  ProfileView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct ProfileView: View {
    @Bindable var viewModel: ProfileViewModel
    let userId: String
    @Environment(\.appRouter) private var appRouter
    @Environment(\.featureFlags) private var featureFlags
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Profile Header
                VStack(spacing: 15) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 100))
                        .foregroundColor(.gray)
                    
                    if let user = viewModel.viewState.user {
                        Text(user.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 20) {
                        Button("Edit Profile") {
                            viewModel.navigate(to: .editProfile, style: .sheet(detents: [.large]))
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Share") {
                            viewModel.navigate(to: .shareProfile, style: .sheet(detents: [.large]))
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                
                // Stats
                HStack(spacing: 40) {
                    VStack {
                        Text("128")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Posts")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Button(action: {
                        viewModel.navigate(to: .followers(userId: userId), style: .push)
                    }) {
                        VStack {
                            Text("1.2K")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Followers")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button(action: {
                        viewModel.navigate(to: .followers(userId: userId), style: .push)
                    }) {
                        VStack {
                            Text("456")
                                .font(.title2)
                                .fontWeight(.bold)
                            Text("Following")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                if featureFlags.isEnabled(.achievements) {
                    Button("View Achievements") {
                        viewModel.navigate(to: .achievements, style: .push)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .onAppear {
            viewModel.loadUser()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Settings") {
                    viewModel.navigate(to: .settings, style: .push)
                }
            }
        }
    }
}
