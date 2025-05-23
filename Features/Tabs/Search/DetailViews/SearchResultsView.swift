//
//  SearchResultsView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct SearchResultsView: View {
    let query: String
    
    var body: some View {
        Text("Results for: \(query)")
            .navigationTitle("Results")
    }
}
