//
//  EditProfileView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    let profile: Profile
    
    // form properties
    @State private var name = ""
    @State private var targetAge: Int = 0
    @State private var selectedDate = Date()
    
    @State private var showNameForm: Bool = false
    @State private var showBirthdateForm: Bool = false
    @State private var showTargetAgeForm: Bool = true
    
    @State private var displayWheelDatePickerStyle: Bool = false
    @State private var displayNumpadFormatStyle: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 50) {
                    VStack(alignment: .leading) {
                        Text("Select a setting to edit")
                            .font(.title3).bold()
                            .foregroundStyle(.secondary)
                        HStack(spacing: 20) {
                            // TODO: On tap shows related form with animation
                            
                            Button(action: {
                                withAnimation(.spring(duration: 1)) {
                                    showBirthdateForm = false
                                    showTargetAgeForm = false
                                    showNameForm.toggle()
                                }
                            }) {
                                VStack(spacing: 10) {
                                    Text("🙋 Name")
                                        .foregroundStyle(.secondary)
                                    Text(name).bold()
                                }
                                .frame(width: 100, height: 100)
                                .glass(cornerRadius: 20)
                            }
                            
                            Button(action: {
                                withAnimation(.spring(duration: 1)) {
                                    showNameForm = false
                                    showTargetAgeForm = false
                                    showBirthdateForm.toggle()
                                }
                            }) {
                                VStack(spacing: 10) {
                                    Text("🥳 Age")
                                        .foregroundStyle(.secondary)
                                    Text("\(profile.age)y").bold()
                                }
                                .frame(width: 100, height: 100)
                                .glass(cornerRadius: 20)
                            }
                            
                            Button(action: {
                                withAnimation(.spring(duration: 1)) {
                                    showBirthdateForm = false
                                    showNameForm = false
                                    showTargetAgeForm.toggle()
                                }
                            }) {
                                VStack(spacing: 10) {
                                    Text("🎯 Target")
                                        .foregroundStyle(.secondary)
                                    Text("\(targetAge)y").bold()
                                }
                                .frame(width: 100, height: 100)
                                .glass(cornerRadius: 20)
                            }
                        } // HStack
                    }
                    
                    // Name Form
                    if showNameForm {
                        VStack(alignment: .center) {
                            Text("Edit your name")
                                .font(.headline)
                                .foregroundStyle(.secondary)
                            TextField("Name", text: $name)
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
                        }
                        .opacity(showNameForm ? 1 : 0)
                    }
                    
                    // Birthdate Form
                    if showBirthdateForm {
                        VStack(alignment: .center) {
                            HStack(spacing: 40) {
                                Text("Edit your birthdate")
                                    .font(.headline)
                                    .foregroundStyle(.secondary)
                                
                                Button {
                                    withAnimation {
                                        displayWheelDatePickerStyle.toggle()
                                    }
                                } label: {
                                    Image(systemName: displayWheelDatePickerStyle ? "calendar.circle" : "calendar.circle.fill")
                                        .imageScale(.large)
                                }
                            }
                            if displayWheelDatePickerStyle {
                                DatePicker("Birthdate", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.wheel)
                            } else {
                                DatePicker("Birthdate", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                                    .labelsHidden()
                                    .datePickerStyle(.graphical)
                            }
                        }
                    }
                    
                    // Target Age Form
                    if showTargetAgeForm {
                        VStack(alignment: .center) {
                            HStack(spacing: 40) {
                                Text("Edit target age")
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
                                        .keyboardType(.numberPad)
                                        .font(.largeTitle)
                                        .multilineTextAlignment(.center)
                                        .frame(width: 80)
                                        .padding()
                                        .glass(cornerRadius: 50)
                                    Text("year")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                    
                                    Spacer()
                                }
                                
                            } else {
                                Picker("Target Age", selection: $targetAge) {
                                    ForEach(profile.age..<99, id: \.self) { target in
                                        Text("\(target) year").tag(target)
                                            .font(.largeTitle)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                        }
                    }
                    
                    
                    
                } // VStack
                .padding()
            } // ZStack
            .onAppear {
                name = profile.name
                targetAge = profile.targetAge
                selectedDate = profile.birthdate
            }
            .navigationTitle("Edit Information")
            .toolbar {
                Button("Done") {
                    if targetAge > 0 && targetAge > profile.age {
                        profile.name = name
                        profile.birthdate = selectedDate
                        profile.targetAge = targetAge
                    }
                    dismiss()
                }
            }
        } // NavStack
    }
}

#Preview {
    let previewBirthdate = Calendar.current.date(byAdding: .year, value: -20, to: .now)
    let previewProfile = Profile(name: "Spike", birthdate: previewBirthdate ?? Date())
    EditProfileView(profile: previewProfile)
}
