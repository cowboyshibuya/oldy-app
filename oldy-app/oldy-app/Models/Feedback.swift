//
//  Feedback.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import Foundation

struct Feedback: Codable, Hashable {
    let version: String
    let type: FeedbackType
    let title: String
    let description: String
//    let screenshot: String?
    
}

enum FeedbackType: String, Codable, CaseIterable {
    case bug, feature
}

