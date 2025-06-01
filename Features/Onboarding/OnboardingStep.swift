//
//  OnboardingStep.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum OnboardingStep: String, CaseIterable, Sendable {
    case signIn
    case welcome
    case permissions
    case profile
    case preferences
    
    init?(_ rawValue: String?) {
        guard let rawValue = rawValue, let step = OnboardingStep(rawValue: rawValue) else {
            return nil
        }
        self = step
    }
    
    var isRequired: Bool {
        switch self {
        case .permissions, .profile:
            return true
        case .preferences:
            return false
        default:
            return false
        }
    }
    
    static var requiredSteps: [OnboardingStep] {
        allCases.filter { $0.isRequired }
    }
    
    var iconName: String {
        switch self {
        case .signIn: return "person.fill"
        case .welcome: return "hand.wave.fill"
        case .permissions: return "bell.fill"
        case .profile: return "person.crop.circle.fill"
        case .preferences: return "slider.horizontal.3"
        }
    }
    
    var title: String {
        switch self {
        case .signIn: return "Sign In"
        case .welcome: return "Welcome!"
        case .permissions: return "Stay Updated"
        case .profile: return "Create Profile"
        case .preferences: return "Set Preferences"
        }
    }
    
    var subtitle: String {
        switch self {
        case .signIn: return "Sign in to your account"
        case .welcome: return "Let's get you started with our app"
        case .permissions: return "Enable notifications to stay in the loop"
        case .profile: return "Tell us a bit about yourself"
        case .preferences: return "Customize your experience"
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .signIn: return "Sign In"
        case .permissions: return "Continue"
        case .profile: return "Save Profile"
        case .preferences: return "Save Preferences"
        default: return "Continue"
        }
    }
}
