//
//  MainView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import SwiftUI

struct MainView: View {
    let profile: Profile
    
    @State private var timer: Timer?
    @State private var timeRemaining: TimeInterval = 0
    private var targetDate: Date {
        Calendar.current.date(byAdding: .year, value: profile.targetAge, to: profile.birthdate) ?? profile.birthdate
    }
    
    // filter properties
    @AppStorage("displayDates") private var displayDates = true
    
    @State private var selectedFormat : Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack {
                    HStack(spacing: 30) {
                        ZStack {
                            VStack {
                                Text("🥳 Age").foregroundStyle(.secondary)
                                Text("\(profile.age)y").bold()
                            }
                        }
                        .frame(width: 100, height: 80)
                        .glass(cornerRadius: 20)
                        
                        ZStack {
                            VStack {
                                Text("🎯 Target").foregroundStyle(.secondary)
                                Text("\(profile.targetAge)y").bold()
                            }
                        }
                        .frame(width: 100, height: 80)
                        .glass(cornerRadius: 20)
                    }
                    Spacer()
                    
                    ZStack {
                        VStack(spacing: 10) {
                            Text("Time left").bold()
                                .foregroundStyle(.black.opacity(0.5))
                                .font(.caption)
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background(Capsule().fill(.white))
                                .opacity(0.8)
                            Spacer()
                            
                            Text(formatTime(timeRemaining, selectedFormat: selectedFormat))
                                .font(.largeTitle)
                                .monospacedDigit()
                            
                            Spacer()
                        }
                        .padding()
                    }
                    .frame(minWidth: 250, idealWidth: 250, maxWidth: .infinity)
                    .frame(minHeight: 300, idealHeight: 400, maxHeight: .infinity)
                    .glass(cornerRadius: 20)
                    .padding(.top, 40)
                    .padding()
                    .onTapGesture {
                        if selectedFormat < 4 {
                            selectedFormat += 1
                        } else {
                            selectedFormat = 0
                        }
                    }
                    
                    Spacer()
                    footerView
                } // VStack
                .padding()
                .onAppear {
                    startTimer(to: targetDate)
                }
                .onDisappear {
                    timer?.invalidate()
                }
            } // Zstack
            .navigationTitle("daysl")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                NavigationLink(destination: SettingsView(profile: profile)) {
                    Image(systemName: "gear")
                }
            }
        } // NavStack
    }
    
    private func updateTimeRemaining(to date: Date) {
        let diff = date.timeIntervalSinceNow
        timeRemaining = max(diff, 0) // don't go below zero
        if diff <= 0 {
            // stop timer if time passed
            timer?.invalidate()
        }
    }
    
    private func startTimer(to date: Date) {
        timer?.invalidate()
        
        updateTimeRemaining(to: date)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            updateTimeRemaining(to: date)
        }
    }
    
    private func formatTime(_ interval: TimeInterval, selectedFormat: Int) -> String {
        let totalSeconds = Int(interval)
        
        let days = totalSeconds / 86400
        let hours = (totalSeconds % 86400) / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        
        switch selectedFormat {
        case 0:
            return String(format: "%d days, %2dh:%2dmin:%2dsec", days, hours, minutes, seconds)
        case 1:
            return String(format: "%d days", days)
        case 2:
            return String(format: "%d days, %2d hours", days, hours)
        case 3:
            return String(format: "%d days, %2d hours, %2d minutes", days, hours, minutes)
        case 4:
            return String(format: "%dd:%2dh:%2dmin", days, hours, minutes)
        default:
            return String(format: "%d days, %2dh:%2dmin:%2dsec", days, hours, minutes, seconds)
        }
    }
}

#Preview {
    let previewBirthdate = Calendar.current.date(byAdding: .year, value: -20, to: .now)
    let previewProfile = Profile(name: "Spike", birthdate: previewBirthdate ?? Date())
    MainView(profile: previewProfile)
}
