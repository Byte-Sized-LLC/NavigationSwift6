//
//  OnboardingStepView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation
import SwiftUI

struct OnboardingStepView: View {
    let step: OnboardingStep
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: step.iconName)
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(step.title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(step.subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            // Additional content for specific steps
            if step == .permissions {
                Button(action: requestNotificationPermission) {
                    Label("Enable Notifications", systemImage: "bell.badge")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40)
            }
            
            if step == .profile {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Tap to add profile photo")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
            }
            
            Spacer()
            
            Button(action: onComplete) {
                Text(step.buttonTitle)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 50)
        }
    }
    
    private func requestNotificationPermission() {
        // In a real app, you would request notification permissions here
        print("Requesting notification permission")
    }
}
