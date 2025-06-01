//
//  SwiftDataPersistance.swift
//  GenericNavigation
//
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
        // Enable autosave to ensure changes persist
        self.modelContext.autosaveEnabled = true
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
        // First fetch the object from context to ensure we have the right instance
        if let existingObject = modelContext.model(for: object.persistentModelID) as? T {
            modelContext.delete(existingObject)
        } else {
            // If not found by ID, try to delete the object directly
            modelContext.delete(object)
        }
        try modelContext.save()
    }
    
    func deleteAll<T: PersistentModel>(_ type: T.Type) async throws {
        try modelContext.delete(model: type)
        try modelContext.save()
    }
    
    func count<T: PersistentModel>(_ type: T.Type) async throws -> Int {
        let descriptor = FetchDescriptor<T>()
        return try modelContext.fetchCount(descriptor)
    }
    
    func update<T: PersistentModel>(_ object: T) async throws {
        // SwiftData automatically tracks changes to fetched objects
        // Just ensure we save the context
        try modelContext.save()
    }
}
