//
//  DefaultButton.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import Foundation
import SwiftUI

struct DefaultButton: View {
    let icon: String
    var title: String?
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .imageScale(.large)
                if let title = title {
                    Text(title).bold()
                }
            }
            .padding()
            .glass(cornerRadius: 30)
        }
    }
}
