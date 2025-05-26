//
//  ViewModel.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import Foundation

@MainActor
protocol ViewModel: Observable {
    associatedtype StoreType: Store
    
    var store: StoreType { get }
}
