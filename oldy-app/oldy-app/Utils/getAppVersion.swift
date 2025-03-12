//
//  getAppVersion.swift
//  oldy-app
//
//  Created by Spike Hermann on 12/03/2025.
//

import Foundation

public func getAppVersion() -> String {
    if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return appVersion
    }
    
    return "Unknown"
}

public func getBuildNumber() -> String {
    if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
        return buildNumber
    }
    return "Unknown"
}
