//
//  FooterView.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import Foundation
import SwiftUI

public var footerView: some View {
    HStack {
        VStack {
            Text("@cowboyshibuya")
            Text("v\(getAppVersion())" + "\(getBuildNumber())")
        }
    }
    .font(.footnote)
    .foregroundStyle(.secondary)
}



