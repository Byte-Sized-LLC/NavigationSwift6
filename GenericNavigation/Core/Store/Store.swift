//
//  Store.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

protocol Store: Sendable {
    associatedtype State: Sendable
    associatedtype Action: Sendable
    
    func getState() async -> State
    func dispatch(_ action: Action) async
    var stateStream: AsyncStream<State> { get async }
}
