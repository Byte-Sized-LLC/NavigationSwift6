//
//  Item.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftData
import Foundation

@Model
final class Item: Codable, Sendable {
    @Attribute(.unique) var id: String
    var title: String
    var itemDescription: String
    var imageURL: String?
    var createdAt: Date
    var updatedAt: Date
    
    init(id: String, title: String, description: String, imageURL: String? = nil) {
        self.id = id
        self.title = title
        self.itemDescription = description
        self.imageURL = imageURL
        self.createdAt = Date()
        self.updatedAt = Date()
    }
    
    // Codable conformance for non-SwiftData persistence
    enum CodingKeys: String, CodingKey {
        case id, title
        case itemDescription = "description"
        case imageURL, createdAt, updatedAt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.itemDescription = try container.decode(String.self, forKey: .itemDescription)
        self.imageURL = try container.decodeIfPresent(String.self, forKey: .imageURL)
        self.createdAt = try container.decodeIfPresent(Date.self, forKey: .createdAt) ?? Date()
        self.updatedAt = try container.decodeIfPresent(Date.self, forKey: .updatedAt) ?? Date()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encodeIfPresent(imageURL, forKey: .imageURL)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
