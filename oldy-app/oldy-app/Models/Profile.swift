//
//  Item.swift
//  oldy-app
//
//  Created by Spike Hermann on 04/03/2025.
//

import Foundation
import SwiftData

@Model
final class Profile {
    var name: String
    var birthdate: Date
    var targetAge: Int
    var age: Int {
        Calendar.current.component(.year, from: Date()) - Calendar.current.component(.year, from: birthdate)
    }
    
    init(name: String, birthdate: Date, targetAge: Int = 85) {
        self.name = name
        self.birthdate = birthdate
        self.targetAge = targetAge
    }
}
