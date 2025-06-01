//
//  OnboardingChecklistView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct OnboardingChecklistView: View {
    @Environment(OnboardingRouter.self) private var onboardingRouter
    @Environment(AppDependencies.self) private var dependencies
    @Environment(OnboardingStateManager.self) private var stateManager
    @Environment(AppRouter.self) private var appRouter
    
    @State private var showCompletionAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                Text("Setup Your Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Complete the steps below to get started")
                    .font(.body)
                    .foregroundColor(.secondary)
                
                // Progress Bar
                ProgressBarView(progress: stateManager.progress)
                    .padding(.horizontal)
                    .animation(.spring(), value: stateManager.progress)
            }
            .padding(.vertical, 24)
            
            // Checklist
            ScrollView {
                VStack(spacing: 16) {
                    // Required Steps
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Required Steps")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(OnboardingStep.allCases, id: \.self) { step in
                            ChecklistItemView(
                                step: step,
                                isCompleted: stateManager.isStepCompleted(step),
                                isOptional: !step.isRequired,
                                action: {
                                    guard !stateManager.isStepCompleted(step) else { return }
                                    navigateToStep(step)
                                }
                            )
                        }
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Setup Progress")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            if stateManager.allRequiredStepsCompleted {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Complete") {
                        showCompletionAlert = true
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .alert("Complete Setup?", isPresented: $showCompletionAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Complete") {
                completeOnboarding()
            }
        } message: {
            Text("You've completed all required steps. You can always access optional settings later.")
        }
    }
    
    private func navigateToStep(_ step: OnboardingStep) {
        onboardingRouter.navigate(to: OnboardingRoute.step(step), style: .push)
    }
    
    @MainActor
    private func completeOnboarding() {
        Task {
            await dependencies.analyticsService.track(.custom("onboarding_completed", parameters: [
                "completed_steps": String(stateManager.completedSteps.count),
                "total_steps": String(OnboardingStep.allCases.count)
            ]))
            
            // Complete onboarding which will trigger navigation to main app
            stateManager.completeOnboarding()
        }
    }
}

struct ChecklistItemView: View {
    let step: OnboardingStep
    let isCompleted: Bool
    let isOptional: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Completion indicator
                ZStack {
                    Circle()
                        .stroke(isCompleted ? Color.green : Color.gray.opacity(0.3), lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if isCompleted {
                        Image(systemName: "checkmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                
                // Icon
                Image(systemName: step.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(isCompleted ? .green : .blue)
                    .frame(width: 30)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(step.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        if isOptional {
                            Text("Optional")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(step.subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color.gray.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isCompleted ? Color.green.opacity(0.3) : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
}

struct ProgressBarView: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 8)
                
                // Progress
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 8)
            }
        }
        .frame(height: 8)
    }
}
