//
//  ContentView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @Query private var profiles: [Profile]

    var body: some View {
        Group {
            if let profile = profiles.first {
                 MainView(profile: profile)
            } else {
                 SetUpProfileView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Profile.self, inMemory: true)
}
