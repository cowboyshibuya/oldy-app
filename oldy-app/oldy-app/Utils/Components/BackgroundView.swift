//
//  BackgroundView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import Foundation
import SwiftUI

struct BackgroundView : View {
    var body: some View {
        LinearGradient(colors: [.purple.opacity(0.5), .red.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
        
        Color.gray
            .opacity(0.25)
            .ignoresSafeArea()
        
        Color.white
            .opacity(0.7)
            .blur(radius: 200)
            .ignoresSafeArea()
    }
}
