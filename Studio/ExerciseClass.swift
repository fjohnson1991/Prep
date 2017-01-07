//
//  ExerciseClass.swift
//  Studio
//
//  Created by Felicity Johnson on 1/7/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import Foundation
import UIKit

class ExerciseClass {
    var name: String
    var type: String
    var instructor: String
    var participants: [User]
    var time: Date
    var duration: Double
    
    init(name: String, type: String, instructor: String, participants: [User], time: Date, duration: Double) {
        self.name = name
        self.type = type
        self.instructor = instructor
        self.participants = participants
        self.time = time
        self.duration = duration
    }
}
