//
//  OnboardingStep.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

enum OnboardingStep: String, CaseIterable, Sendable {
    case welcome
    case permissions
    case profile
    case preferences
    case completion
    
    var next: OnboardingStep? {
        guard let currentIndex = OnboardingStep.allCases.firstIndex(of: self) else { return nil }
        let nextIndex = currentIndex + 1
        return nextIndex < OnboardingStep.allCases.count ? OnboardingStep.allCases[nextIndex] : nil
    }
}
