//
//  OnboardingPreferencesView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingPreferencesView: View {
    @State private var viewModel: OnboardingPreferencesViewModel
    @Environment(\.onboardingStateManager) private var stateManager

    init(onboardingRouter: OnboardingRouter, dependencies: AppDependencies) {
        self._viewModel = State(initialValue: OnboardingPreferencesViewModel(
            onboardingRouter: onboardingRouter,
            dependencies: dependencies
        ))
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 16) {
                Text("Customize Your Experience")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose your preferences to personalize the app")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .foregroundColor(.secondary)
            }
            
            // Preferences
            VStack(spacing: 20) {
                PreferenceToggleView(
                    title: "Daily Digest",
                    description: "Receive daily summary emails",
                    isOn: $viewModel.dailyDigest
                )
                
                PreferenceToggleView(
                    title: "Auto-Play Videos",
                    description: "Videos play automatically",
                    isOn: $viewModel.autoPlayVideos
                )
                
                PreferenceToggleView(
                    title: "Show Online Status",
                    description: "Let others see when you're active",
                    isOn: $viewModel.showOnlineStatus
                )
                
                // Language Selection
                VStack(alignment: .leading, spacing: 8) {
                    Text("Language")
                        .font(.headline)
                    
                    Picker("Language", selection: $viewModel.selectedLanguage) {
                        ForEach(viewModel.languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: { viewModel.savePreferences(stateManager: stateManager) }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
        .navigationTitle("Preferences")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PreferenceToggleView: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: .blue))
        }
    }
}
