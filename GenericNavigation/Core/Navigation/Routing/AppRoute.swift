//
//  AppRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

protocol AppRoute: Hashable, Identifiable, Sendable {
    var id: Self { get }
    var featureFlagKey: FeatureFlag? { get }
}
