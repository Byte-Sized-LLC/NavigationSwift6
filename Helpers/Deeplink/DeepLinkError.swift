//
//  DeepLinkError.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import Foundation

enum DeepLinkError: Error, CustomStringConvertible {
    case missingRouteComponents
    case noNativeRouteFound
    case featureFlagOff(flag: FeatureFlag)
    
    var description: String {
        switch self {
        case .missingRouteComponents:
            return "No route components were found in the URL."
        case .noNativeRouteFound:
            return "No valid native route could be determined from the URL."
        case .featureFlagOff(let flag):
            return "The feature flag '\(flag.rawValue)' is disabled."
        }
    }
}
