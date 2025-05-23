//
//  DetailView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct DetailView: View {
    let itemId: String
    
    var body: some View {
        Text("Detail View for item: \(itemId)")
            .navigationTitle("Detail")
    }
}
