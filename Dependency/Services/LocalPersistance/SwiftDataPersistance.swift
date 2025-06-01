//
//  SwiftDataPersistance.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 6/1/25.
//

import SwiftData
import Foundation

protocol SwiftDataPersistable: PersistentModel, Codable {
    associatedtype IDType: Codable
    var id: IDType { get }
}

actor SwiftDataPersistence {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    init(modelTypes: [any PersistentModel.Type]) throws {
        let schema = Schema(modelTypes)
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        self.modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        self.modelContext = ModelContext(modelContainer)
    }
    
    func save<T: PersistentModel>(_ objects: [T]) async throws {
        for object in objects {
            modelContext.insert(object)
        }
        try modelContext.save()
    }
    
    func save<T: PersistentModel>(_ object: T) async throws {
        modelContext.insert(object)
        try modelContext.save()
    }
    
    func load<T: PersistentModel>(_ type: T.Type) async throws -> [T] {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetch(descriptor)
    }
    
    func load<T: PersistentModel>(_ type: T.Type,
                                  predicate: Predicate<T>? = nil,
                                  sortBy: [SortDescriptor<T>] = []) async throws -> [T] {
        let descriptor = FetchDescriptor<T>(predicate: predicate, sortBy: sortBy)
        return try modelContext.fetch(descriptor)
    }
    
    func delete<T: PersistentModel>(_ object: T) async throws {
        modelContext.delete(object)
        try modelContext.save()
    }
    
    func deleteAll<T: PersistentModel>(_ type: T.Type) async throws {
        let objects = try await load(type)
        for object in objects {
            modelContext.delete(object)
        }
        try modelContext.save()
    }
    
    func count<T: PersistentModel>(_ type: T.Type) async throws -> Int {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetchCount(descriptor)
    }
}
