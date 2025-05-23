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
    let onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: iconName)
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
            
            Button(action: onNext) {
                Text(buttonTitle)
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
    
    private var iconName: String {
        switch step {
        case .welcome: return "hand.wave.fill"
        case .permissions: return "bell.fill"
        case .profile: return "person.crop.circle.fill"
        case .preferences: return "slider.horizontal.3"
        case .completion: return "checkmark.circle.fill"
        }
    }
    
    private var title: String {
        switch step {
        case .welcome: return "Welcome!"
        case .permissions: return "Stay Updated"
        case .profile: return "Create Profile"
        case .preferences: return "Set Preferences"
        case .completion: return "All Set!"
        }
    }
    
    private var subtitle: String {
        switch step {
        case .welcome: return "Let's get you started with our app"
        case .permissions: return "Enable notifications to stay in the loop"
        case .profile: return "Tell us a bit about yourself"
        case .preferences: return "Customize your experience"
        case .completion: return "You're ready to explore"
        }
    }
    
    private var buttonTitle: String {
        switch step {
        case .completion: return "Get Started"
        default: return "Continue"
        }
    }
}
