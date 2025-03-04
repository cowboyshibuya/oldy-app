//
//  SettingsView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    let profile: Profile
    
    // sheet properties
    @State private var showBackgroundColorSelectionSheet: Bool = false
    @State private var showEditProfileSheet: Bool = false
    
    @State private var showResetAlert = false

    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                VStack(spacing: 20) {
                    // TODO
                    // Random quotes about time
                    Text("Don't lose this precious time by scrolling your feed !")
                        .padding()

                    VStack(spacing: 20) {
                        Text("🎯\(profile.targetAge) years old")
                            .font(.headline)
                            .padding()
                        //TODO: Random picture here
                        Image("selfie")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                        
                        VStack(spacing: 5) {
                            //TODO: Store user name
                            Text("\(profile.name), \(profile.age)")
                                .font(.title2).bold()
                            Text("Born on **\(profile.birthdate.formatted(date: .abbreviated, time: .omitted))**").foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .glass(cornerRadius: 50)
                    
                    VStack(spacing: 20) {
                        HStack {
                            DefaultButton(icon: "pencil", title: "Edit my profile", action: {
                                showEditProfileSheet.toggle()
                            })
                        }
                    }
                    .foregroundStyle(.white)
                    Spacer()
                    
                    VStack(spacing: 15) {
                        // Trust & Security
                        Button("Trust and Security") {}
                            .bold()
                        // Contact US
                        Button("Contact Us"){}
                            .bold()
                    }
                    .foregroundStyle(.white)
                    Spacer()
                } // VStack
                .padding()
            } // ZStack
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Menu {
                    Button("Report a bug") {}
                    Button("Reset", role: .destructive) {
                        resetProfile()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
                .foregroundColor(.white)
            }
            .sheet(isPresented: $showBackgroundColorSelectionSheet) {
                
            }
            .sheet(isPresented: $showEditProfileSheet) {
                EditProfileView(profile: profile)
                    .presentationDetents([.medium])
            }
            .alert("Reset App", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) {
                    withAnimation {
                        context.delete(profile)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to reset your profile? All your informations will be cleared.")
            }
        } // NavStack
    }
    
    private func resetProfile() {
        showResetAlert = true
    }
}





#Preview {
    let previewBirthdate = Calendar.current.date(byAdding: .year, value: -20, to: .now)
    let previewProfile = Profile(name: "Spike", birthdate: previewBirthdate ?? Date())
    SettingsView(profile: previewProfile)
}
