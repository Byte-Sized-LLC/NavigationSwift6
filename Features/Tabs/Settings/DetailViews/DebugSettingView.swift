//
//  DebugSettingView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct DebugSettingsView: View {
    @Environment(\.featureFlags) private var featureFlags
    @Environment(\.appRouter) private var appRouter
    @AppStorage("environment") private var environment: AppEnvironment = .production
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Environment") {
                    Picker("Environment", selection: $environment) {
                        ForEach(AppEnvironment.allCases, id: \.self) { env in
                            Text(env.rawValue.capitalized).tag(env)
                        }
                    }
                    
                    Text("Base URL: \(environment.baseURL)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section("Feature Flags") {
                    ForEach(allFlags, id: \.rawValue) { flag in
                        Toggle(flag.name, isOn: Binding(
                            get: { featureFlags.isEnabled(flag) },
                            set: { enabled in
                                Task {
                                    await featureFlags.setOverride(flag, enabled: enabled)
                                }
                            }
                        ))
                    }
                    
                    Button("Reset All Overrides") {
                        Task {
                            await featureFlags.clearOverrides()
                        }
                    }
                    .foregroundColor(.red)
                }
                
                Section("App State") {
                    Button("Reset Onboarding") {
                        Task { @MainActor in
                            appRouter.resetOnboarding()
                            dismiss()
                        }
                    }
                    
                    Text("Last Onboarding Step: \(appRouter.currentOnboardingStep.rawValue)")
                        .font(.caption)
                }
                
                Section("Debug Actions") {
                    Button("Trigger Test Crash") {
                        fatalError("Test crash")
                    }
                    .foregroundColor(.red)
                    
                    Button("Clear All Data") {
                        // Clear implementation
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Debug Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var allFlags: [FeatureFlag] {
        [.newOnboarding, .advancedSearch, .premiumFeatures, .achievements, .featuredContent, .debugMenu]
    }
}
