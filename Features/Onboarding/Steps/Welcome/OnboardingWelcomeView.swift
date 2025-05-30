//
//  OnboardingWelcomeView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingWelcomeView: View {
    @State private var viewModel: OnboardingWelcomeViewModel
    @Environment(OnboardingStateManager.self) private var stateManager

    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self._viewModel = State(initialValue: OnboardingWelcomeViewModel(
            onboardingRouter: onboardingRouter,
            dependencies: dependencies
        ))
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            // Animation
            Image(systemName: "hand.wave.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(viewModel.waveAnimation ? -15 : 15))
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: viewModel.waveAnimation)
                .onAppear { viewModel.startAnimation() }
            
            VStack(spacing: 16) {
                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("We're excited to have you here. Let's get your account set up in just a few steps.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { viewModel.completeStep(stateManager: stateManager) }) {
                Text("Get Started")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .navigationTitle("Welcome")
        .navigationBarTitleDisplayMode(.inline)
    }
}
