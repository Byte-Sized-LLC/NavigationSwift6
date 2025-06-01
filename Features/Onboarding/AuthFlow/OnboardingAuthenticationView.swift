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
    
    @State private var username = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @FocusState private var focusedField: Field?
    
    enum Field {
        case username, password
    }
    
    private var canAuthenticate: Bool {
        !username.isEmpty && !password.isEmpty
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
                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {
                        authenticate()
                    }
                
                if let error = errorMessage {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, 40)
            
            // Sign In Button
            Button(action: authenticate) {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Sign In")
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(canAuthenticate ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(!canAuthenticate || isLoading)
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
    
    private func authenticate() {
        guard canAuthenticate else { return }
        
        Task {
            isLoading = true
            errorMessage = nil
            
            do {
                // Simulate authentication
                try await Task.sleep(nanoseconds: 1_500_000_000)
                
                // Demo credentials check
                if username.lowercased() == "demo" && password == "demo" {
                    await dependencies.analyticsService.track(.custom("onboarding_authenticated", parameters: nil))
                    
                    // Mark user as authenticated
                    stateManager.setUserAuthenticated(true)
                    
                    // Check authentication state to determine next step
                    let authState = await stateManager.checkAuthenticationState()
                    
                    switch authState {
                    case .onboardingComplete:
                        // User has completed everything, this shouldn't happen in onboarding flow
                        // but if it does, complete onboarding
                        stateManager.completeOnboarding()
                        
                    case .needsOnboarding(let nextStep):
                        // Navigate to the next incomplete step
                        onboardingRouter.navigate(to: .checklist, style: .push)

                        
                    case .needsFullOnboarding:
                        // New user, start with welcome
                        onboardingRouter.navigate(to: .checklist, style: .push)

                    case .authenticated:
                        // Has profile but might need to complete some steps
                        onboardingRouter.navigate(to: .checklist, style: .push)

                        
                    case .notAuthenticated:
                        // This shouldn't happen after successful auth
                        errorMessage = "Authentication failed. Please try again."
                    }
                    
                } else {
                    throw AuthenticationError.invalidCredentials
                }
            } catch {
                errorMessage = "Invalid username or password"
                await dependencies.analyticsService.track(.custom("onboarding_auth_failed", parameters: nil))
            }
            
            isLoading = false
        }
    }
}
