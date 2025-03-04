//
//  SetUpProfileView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import SwiftUI
import SwiftData

struct SetUpProfileView: View {
    @Environment(\.modelContext) private var context
    
    // form properties
    @State private var name: String = ""
    @State private var selectedDate = Date().addingTimeInterval(-500000)
    @State private var targetAge : Int = 30
    @State private var showButton = false
    
    // animation properties
    @State private var showNameForm: Bool = false
    @State private var showDateForm: Bool = false
    @State private var showTargetAgeForm: Bool = false
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDateFocused: Bool
    
    @State private var showSkipAlert = false
    
    var body: some View {
        #warning("Need to fix the background animation")
        NavigationStack {
            ZStack {
                BackgroundView()
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 30) {
                        if showNameForm {
                            nameForm.opacity(showNameForm ? 1 : 0)
                        }
                        
                        if showDateForm {
                            dateForm.opacity(showDateForm ? 1 : 0)
                        }
                        
                        if showTargetAgeForm {
                            targetAgeForm
                            .opacity(showTargetAgeForm ? 1 : 0)
                        }
                    }
                    .padding()
                    
                    if showButton {
                        Button(action: setUpProfile) {
                            HStack {
                                Spacer()
                                Text("Continue")
                                Image(systemName: "arrow.right")
                                Spacer()
                            }
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).fill(.white))
                            .foregroundStyle(.black)
                            .padding()
                        }
                    }
                } // VStack
                .padding()
                .onAppear {
                    withAnimation(.spring(duration: 1)) {
                        showNameForm = true
                    }
                }
                .navigationTitle("Let's set your profile 🧑‍🎤")
                .toolbar {
                    Button("Skip") {
                        showSkipAlert = true
                    }
                    .foregroundStyle(.secondary)
                }
                .alert("Are you sure you want to skip ?", isPresented: $showSkipAlert) {
                    Button("Skip") {
                        skipSetUp()
                    }
                    Button("Cancel", role: .cancel) {}
                } message: {
                    Text("A random target age will set for you. But don't worry, you can change it any time 😃!")
                }
            } // ZStack
        } // NavStack
    }
    
    private var nameForm: some View {
        VStack {
            Text("How should we call you?")
                .font(.headline)
            TextField("Name", text: $name)
                .focused($isNameFocused)
                .padding()
                .glass(cornerRadius: 20)
                .onChange(of: isNameFocused) { _,focused in
                    if !focused {
                        withAnimation(.spring(duration: 1)) {
                            showDateForm = true
                        }
                    }
                }
        }
    }
    
    private var dateForm: some View {
        VStack {
            Text("Select your birthdate")
                .font(.headline)
            DatePicker("Birthdate", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .focused($isDateFocused)
                .datePickerStyle(.compact)
                .onChange(of: selectedDate) {
                    withAnimation(.spring(duration: 1)) {
                        showTargetAgeForm = true
                        showButton = true
                    }
                }
                .labelsHidden()
        }
    }
    
    private var targetAgeForm: some View {
        VStack {
            Text("Select a target age")
                .font(.headline)
            Picker("Target Age", selection: $targetAge) {
                ForEach(18..<100, id: \.self) { age in
                    Text("\(age)").tag(age)
                }
            }
            .labelsHidden()
            .pickerStyle(.wheel)
        }
    }
    
    private func setUpProfile() {
        withAnimation {
            let newProfile = Profile(name: name, birthdate: selectedDate, targetAge: Int(targetAge))
            context.insert(newProfile)
        }
    }
    
    private func skipSetUp() {
        withAnimation {
            let newProfile = Profile(name: "Anonymous", birthdate: Date(), targetAge: Int.random(in: 18..<100))
            context.insert(newProfile)
        }
    }
}


#Preview {
    SetUpProfileView()
}

