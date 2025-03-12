//
//  FeatureRequestView.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import SwiftUI

struct FeatureRequestView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var feedbackVM : FeedbackViewModel = .shared
    @FocusState private var isDescriptionFocused : Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Color.black.opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("What feature would you be happy to have here?")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        
                        TextField("New colors for background", text: $feedbackVM.title)
                            .padding()
                            .glass(cornerRadius: 20)
                            .overlay (
                                Button {
                                    if !feedbackVM.title.isEmpty {
                                        feedbackVM.title = ""
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.secondary)
                                }
                                    .padding(.trailing, 20)
                                    .opacity(feedbackVM.title.isEmpty ? 0 : 1)
                                ,alignment: .trailing
                            )
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Describe the feature")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $feedbackVM.description)
                            .focused($isDescriptionFocused)
                            .padding()
                            .textEditorStyle(.plain)
                            .glass(cornerRadius: 20)
                            .overlay (
                                Text("""
                            Please provide as much details as possible:
                            
                            - Page
                            - Bug's description
                            - iPhone model
                            - ...
                            
                            All details will helps us to fix it quickly! 
                            
                            Thanks you very much 🙏
                            """)
                            .foregroundStyle(.secondary)
                            .fontWeight(.bold)
                            .offset(y: 50)
                            .opacity(isDescriptionFocused || !feedbackVM.description.isEmpty ? 0 : 1)
                            )
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    
                    DefaultButton(icon: "checkmark.circle", title: "Submit") {
                        Task {
                             await feedbackVM.sendFeatureRequest()
                        }
                    }
                }
                .navigationTitle("💫 Feature Request")
                .toolbar {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                .alert("Success", isPresented: .constant(feedbackVM.successMessage != nil)) {
                    Button("Ok") {
                        dismiss()
                        feedbackVM.successMessage = nil
                    }
                } message: {
                    if let message = feedbackVM.successMessage {
                        Text(message)
                    }
                }
                .alert("Error", isPresented: .constant(feedbackVM.errorMessage != nil)) {
                    Button("Ok") {
                        dismiss()
                        feedbackVM.errorMessage = nil
                    }
                } message: {
                    if let message = feedbackVM.errorMessage {
                        Text(message)
                    }
                }
            }
        }
    }
}

#Preview {
    FeatureRequestView()
}
