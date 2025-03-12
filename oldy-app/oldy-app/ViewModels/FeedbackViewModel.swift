//
//  FeedbackViewModel.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import Foundation

@Observable
final class FeedbackViewModel {
    static let shared = FeedbackViewModel()
    let feedbackService: FeedbackService
    init(feedbackService: FeedbackService = .shared) {
        self.feedbackService = feedbackService
    }
    
    private(set) var isLoading = false
    var errorMessage: String?
    var successMessage: String?
    
    var version: String {
        getAppVersion() + getBuildNumber()
    }
    var title = ""
    var description = ""
//    var screenshot: String?
    
    
    // Bug Report
    @MainActor
    func sendBugReport() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if !title.isEmpty || !description.isEmpty {
                let feedback = Feedback(
                    version: version,
                    type: .bug,
                    title: title,
                    description: description
                )
                
                try await feedbackService.sendFeedback(feedback)
                
                successMessage = "Feedback sent successfully!"
                print("Feedback sent!")
            } else { return }
        } catch {
            errorMessage = "Failed to send feedback. Please try again later."
//            fatalError("Failed to send feedback: \(error)")
        }
    }
    
    
    // Feature Request
    @MainActor
    func sendFeatureRequest() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if !title.isEmpty || !description.isEmpty {
                let feedback = Feedback(
                    version: version,
                    type: .feature,
                    title: title,
                    description: description
                )
                
                try await feedbackService.sendFeedback(feedback)
                successMessage = "Feedback sent successfully!"
                
            } else { return }
        } catch {
            self.errorMessage = "Something went wrong. Please try again later."
        }
    }
}
