//
//  FollowingView.swift
//  GenericNavigation
//
//  Created by Dylan Anderson on 5/23/25.
//

import SwiftUI

struct FollowingView: View {
    let userId: String
    
    var body: some View {
        Text("Following by \(userId)")
            .navigationTitle("Following")
    }
}
