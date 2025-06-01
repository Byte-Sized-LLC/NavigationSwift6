//
//  LocalPersistenceService.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/30/25.
//

import Foundation

final class LocalPersistenceService: LocalPersistenceProtocol, @unchecked Sendable {
    private let persistence: any LocalPersistenceProtocol
    
    init(storageType: PersistenceStorageType = .userDefaults) {
        switch storageType {
        case .userDefaults:
            self.persistence = UserDefaultsPersistence()
        case .keychain:
            self.persistence = KeychainPersistence()
        case .swiftData:
            self.persistence = SwiftDataPersistance()
        }
    }
}
