//
//  DependencyContainerProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

protocol DependencyContainerProtocol: Sendable {
    associatedtype API: APIServiceProtocol
    associatedtype User: UserServiceProtocol
    associatedtype Analytics: AnalyticsServiceProtocol
    associatedtype Persistence: LocalPersistenceProtocol
    
    var apiService: API { get }
    var userService: User { get }
    var analyticsService: Analytics { get }
    var persistenceService: Persistence { get }
}

/// Ideas

//protocol NetworkMonitorServiceProtocol: Sendable {
//    var isConnected: Bool { get }
//    var connectionType: ConnectionType { get }
//    func startMonitoring()
//    func stopMonitoring()
//}

//enum ConnectionType {
//    case wifi
//    case cellular
//    case none
//}

//protocol CacheServiceProtocol: Sendable {
//    func cache<T: Codable>(_ value: T, forKey key: String, expiration: TimeInterval?) async
//    func retrieve<T: Codable>(forKey key: String) async -> T?
//    func remove(forKey key: String) async
//    func clearAll() async
//}

//protocol PermissionServiceProtocol: Sendable {
//    func requestPermission(_ permission: Permission) async throws
//    func checkPermission(_ permission: Permission) -> PermissionStatus
//    func openSettings()
//}

//enum Permission {
//    case camera
//    case photoLibrary
//    case microphone
//    case location
//    case notifications
//    case contacts
//}

//enum PermissionStatus {
//    case notDetermined
//    case restricted
//    case denied
//    case authorized
//}

//protocol BiometricServiceProtocol: Sendable {
//    var biometricType: BiometricType { get }
//    var isBiometricAvailable: Bool { get }
//    func authenticate(reason: String) async throws -> Bool
//    func enableBiometric() async throws
//    func disableBiometric() async
//}
//
//enum BiometricType {
//    case none
//    case touchID
//    case faceID
//}
