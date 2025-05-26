//
//  WebRoute.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/24/25.
//

import Foundation

public enum WebRoute: AppRoute {
    public var id: Self { self }

    case custom(URL)

    init(url: URL) {
        self = .custom(url)
    }
    
    var featureFlagKey: FeatureFlag? {
        return nil
    }
}
