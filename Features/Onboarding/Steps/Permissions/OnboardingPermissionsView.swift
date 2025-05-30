//
//  OnboardingPermissionsView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingPermissionsView: View {
    @State private var viewModel: OnboardingPermissionsViewModel
    @Environment(OnboardingStateManager.self) private var stateManager
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self._viewModel = State(initialValue: OnboardingPermissionsViewModel(
            onboardingRouter: onboardingRouter,
            dependencies: dependencies
        ))
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "shield.checkered")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            VStack(spacing: 16) {
                Text("App Permissions")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("We need a few permissions to provide you with the best experience")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.secondary)
            }
            
            // Permission items
            VStack(spacing: 16) {
                PermissionItemView(
                    icon: "bell.fill",
                    title: "Notifications",
                    description: "Get updates about your activities",
                    isGranted: viewModel.notificationsGranted
                )
                
                PermissionItemView(
                    icon: "camera.fill",
                    title: "Camera",
                    description: "Take photos for your profile",
                    isGranted: viewModel.cameraGranted
                )
                
                PermissionItemView(
                    icon: "location.fill",
                    title: "Location",
                    description: "Find nearby content and friends",
                    isGranted: viewModel.locationGranted
                )
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            VStack(spacing: 12) {
                Button(action: { viewModel.requestPermissions(stateManager: stateManager) }) {
                    Text(viewModel.hasRequestedPermissions ? "Continue" : "Grant Permissions")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                if !viewModel.hasRequestedPermissions {
                    Button("Skip for Now") {
                        viewModel.skipPermissions(stateManager: stateManager)
                    }
                    .font(.footnote)
                    .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .navigationTitle("Permissions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PermissionItemView: View {
    let icon: String
    let title: String
    let description: String
    let isGranted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(isGranted ? .green : .gray)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isGranted {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            }
        }
    }
}
