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
    var age: Int {
        Calendar.current.component(.year, from: Date()) - Calendar.current.component(.year, from: selectedDate) - 1
    }
    
    // animation properties
    @State private var showNameForm: Bool = false
    @State private var showDateForm: Bool = false
    @State private var showTargetAgeForm: Bool = false
    
    @FocusState private var isNameFocused: Bool
    @FocusState private var isDateFocused: Bool
    @FocusState private var isTargetAgeFocused: Bool
    
    @State private var showSkipAlert = false
    @State private var displayNumpadFormatStyle: Bool = false
    
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
                .overlay (
                    Button {
                        if !name.isEmpty {
                            name = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.secondary)
                    }
                        .padding(.trailing, 20)
                        .opacity(name.isEmpty ? 0 : 1)
                    ,alignment: .trailing
                )
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
        VStack(alignment: .center) {
            HStack(spacing: 40) {
                Text("Enter a target age")
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
                Button {
                    withAnimation {
                        displayNumpadFormatStyle.toggle()
                    }
                } label: {
                    Image(systemName: displayNumpadFormatStyle ? "hand.point.up.left.and.text.fill" : "textformat.123")
                        .imageScale(.large)
                }
            }
            
            if displayNumpadFormatStyle {
                HStack {
                    Spacer()
                    
                    TextField("Target Age", value: $targetAge, format: .number)
                        .focused($isTargetAgeFocused)
                        .keyboardType(.numberPad)
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .frame(width: 80)
                        .padding()
                        .glass(cornerRadius: 50)
                        .onChange(of: isTargetAgeFocused) {
                            if targetAge < age {
                                targetAge = age
                            }
                        }
                    Text("year")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }
                
            } else {
                Picker("Target Age", selection: $targetAge) {
                    ForEach(age..<99, id: \.self) { target in
                        Text("\(target) year").tag(target)
                            .font(.largeTitle)
                    }
                }
                .pickerStyle(.wheel)
            }
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

