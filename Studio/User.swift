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
    var currentClass: ExerciseClass
    var bpm: String
    var calories: Int
    
    init(name: String, userUniqueKey: String, previousClasses: [ExerciseClass], currentClass: ExerciseClass, bpm: String, calories: Int) {
        self.name = name
        self.userUniqueKey = userUniqueKey
        self.previousClasses = previousClasses
        self.currentClass = currentClass
        self.bpm = bpm
        self.calories = calories
    }
}
