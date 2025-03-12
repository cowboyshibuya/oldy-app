//
//  FeedbackService.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import Foundation

@Observable
final class FeedbackService {
    static let shared = FeedbackService()
    
    func sendBugReports(_ feedback: Feedback) async throws {
        do {
            try await supabase
                .from("oldy-app")
                .insert(feedback)
                .execute()
            
        } catch {
            fatalError("Error sending bug report: \(error)")
        }
    }
}
