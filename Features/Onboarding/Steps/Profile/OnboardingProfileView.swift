//
//  OnboardingProfileView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingProfileView: View {
    @State private var viewModel: OnboardingProfileViewModel
    @FocusState private var isNameFocused: Bool
    
    init(navigationManager: NavigationManager, dependencies: AppDependencies) {
        self._viewModel = State(initialValue: OnboardingProfileViewModel(
            navigationManager: navigationManager,
            dependencies: dependencies
        ))
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Profile Image
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.gray)
                
                Button(action: { viewModel.changePhoto() }) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .offset(x: 40, y: 40)
            }
            
            VStack(spacing: 16) {
                Text("Create Your Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Tell us a bit about yourself")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // Form
            VStack(spacing: 16) {
                TextField("Your Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isNameFocused)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bio (optional)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    TextEditor(text: $viewModel.bio)
                        .frame(height: 80)
                        .padding(8)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: { viewModel.saveProfile() }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.canSave ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.canSave)
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isNameFocused = true
        }
    }
}
