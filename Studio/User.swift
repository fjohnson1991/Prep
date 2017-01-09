//
//  User.swift
//  Studio
//
//  Created by Felicity Johnson on 1/7/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import Foundation
import UIKit

class User {
    var name: String
    var userUniqueKey: String
    var previousClasses: [ExerciseClass]
    var currentClass: ExerciseClass?
    var bpm: String
    var calories: Int?
    var username: String
    var avatarIconName: String?
    var gender: String
    var age: Int
    var location: String
    
    init(name: String, userUniqueKey: String, previousClasses: [ExerciseClass], bpm: String, username: String, gender: String, age: Int, location: String) {
        self.name = name
        self.userUniqueKey = userUniqueKey
        self.previousClasses = previousClasses
        self.bpm = bpm
        self.username = username
        self.gender = gender
        self.age = age
        self.location = location
    }
}
