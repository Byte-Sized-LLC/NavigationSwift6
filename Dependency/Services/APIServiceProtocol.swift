//
//  APIServiceProtocol.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

protocol APIServiceProtocol: Sendable {
    func fetchData<T: Decodable & Sendable>(_ endpoint: String) async throws -> T
}
