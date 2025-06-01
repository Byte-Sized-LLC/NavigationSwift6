//
//  OnboardingAuthenticationView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingAuthenticationView: View {
    @Environment(OnboardingRouter.self) private var onboardingRouter
    @Environment(AppDependencies.self) private var dependencies
    @Environment(OnboardingStateManager.self) private var stateManager
    @State private var viewModel: OnboardingAuthenticationViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username, password
    }
    
    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self._viewModel = State(initialValue: OnboardingAuthenticationViewModel(
            onboardingRouter: onboardingRouter,
            dependencies: dependencies
        ))
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Logo/Icon
            Image(systemName: "app.badge.checkmark.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            // Title
            VStack(spacing: 8) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Sign in to continue")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            // Form
            VStack(spacing: 16) {
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        viewModel.authenticate()
                    }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 40)
            
            // Sign In Button
            Button(action: viewModel.authenticate) {
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.canAuthenticate ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!viewModel.canAuthenticate || viewModel.isLoading)
            .padding(.horizontal, 40)
            
            // Demo credentials hint
            VStack(spacing: 4) {
                Text("Demo credentials")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Username: demo • Password: demo")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            focusedField = .username
        }
    }
}
