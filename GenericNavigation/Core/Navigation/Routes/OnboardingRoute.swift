//
//  OnboardingRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

enum OnboardingRoute: AppRoute {
    var id: Self { self }
    
    case authentication
    case checklist
    case step(OnboardingStep)
    
    var featureFlagKey: FeatureFlag? {
        return nil
    }
}
