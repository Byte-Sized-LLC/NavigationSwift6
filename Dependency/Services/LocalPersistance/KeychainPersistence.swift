//
//  KeychainPersistence.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation
import Security

actor KeychainPersistence: LocalPersistenceProtocol {
    private let service: String
    
    init(service: String = Bundle.main.bundleIdentifier ?? "GenericNavigation") {
        self.service = service
    }

}
