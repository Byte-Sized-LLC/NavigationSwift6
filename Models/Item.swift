//
//  Item.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

struct Item: Identifiable, Codable, Sendable {
    let id: String
    let title: String
    let description: String
    let imageURL: String?
}
