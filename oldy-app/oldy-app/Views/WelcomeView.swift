//
//  WelcomeView.swift
//  oldy-app
//
//  Created by Spike Hermann on 13/03/2025.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("showWelcomePage") private var showWelcomePage: Bool = true
    
    @State private var showAnimation = false
    @State private var showBackgroundAnimation = false
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Color.red.opacity(showBackgroundAnimation ? 0.2 : 0).ignoresSafeArea()
                
                VStack(spacing: 50) {
                    
                    Spacer()
                    
                    Text("👵 Oldy Logo here")
                        .font(.title2)
                    
                    VStack(spacing: 20) {
                        VStack {
                            Text("You're Younger Today")
                                .fontWeight(.bold)
                            Text("Than You'll Ever Be Again.")
                        }
                        .font(.system(size: 30))
                        .opacity(showAnimation ? 1 : 0)
                        
                        Text("Don't waste this precious time.")
                            .font(.title3)
                            .fontWeight(.light)
                    }
                    
                    Spacer()
                    
                    DefaultButton(icon: "arrow.right", title: "Let's Get Started") {
                        withAnimation {
                            showWelcomePage = false
                        }
                    }
                    .opacity(showAnimation ? 1 : 0)
                    .offset(y: showAnimation ? 0 : 100)
                }
                .padding()
            } // Zstack
            .onAppear {
                withAnimation(.spring(duration: 1)) {
                    showAnimation = true
                }
                
                withAnimation(.bouncy(duration: 2).repeatForever()) {
                    showBackgroundAnimation = true
                }
            }
        } // NavStack
    }
}

#Preview {
    WelcomeView()
}
