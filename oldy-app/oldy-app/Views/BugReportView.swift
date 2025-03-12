//
//  BugReportView.swift
//  oldy-app
//
//  Created by Spike Hermann on 10/03/2025.
//

import SwiftUI

struct BugReportView: View {
    @Environment(\.dismiss) private var dismiss
    @State var feedBackVM : FeedbackViewModel = .shared
  
    @FocusState private var isTextEditorFocused : Bool
    // add image
    
    /**
     TODO:
     - set service supabase process to insert in database
     - show alert confirmation when bug is reported
     - implement screenshot feature
     - improve view (potential UI issues in different devices)
     - improve textEditor
     
     **/
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    VStack(alignment: .leading) {
                        Text("What is the issue?")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        TextField("Bug in the settings page", text: $feedBackVM.title)
                            .padding()
                            .glass(cornerRadius: 20)
                            .overlay (
                                Button {
                                    if !feedBackVM.title.isEmpty {
                                        feedBackVM.title = ""
                                    }
                                } label: {
                                    Image(systemName: "xmark.circle")
                                        .foregroundStyle(.secondary)
                                }
                                    .padding(.trailing, 20)
                                    .opacity(feedBackVM.title.isEmpty ? 0 : 1)
                                ,alignment: .trailing
                            )
                    }
                    .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Describe the issue")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        TextEditor(text: $feedBackVM.description)
                            .focused($isTextEditorFocused)
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
                            .opacity(isTextEditorFocused || !feedBackVM.description.isEmpty ? 0 : 1)
                            )
                            .frame(width: .infinity)
                    }
                    .padding(.horizontal)
                    
                    DefaultButton(icon: "checkmark.circle", title: "Submit") {
                        Task { await feedBackVM.sendBugReport() }
                    }
                }
            }
            .navigationTitle("🐞 Report a bug")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
            .alert("Success", isPresented: .constant(feedBackVM.successMessage != nil)) {
                Button("Ok") { feedBackVM.successMessage = nil }
            } message: {
                if let message = feedBackVM.successMessage {
                    Text(message)
                }
            }
        }
    }
}

#Preview {
    BugReportView()
}
