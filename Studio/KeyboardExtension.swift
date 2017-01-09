//
//  KeyboardExtension.swift
//  Studio
//
//  Created by Felicity Johnson on 1/7/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround(isActive: Bool) {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        if isActive == true {
            view.addGestureRecognizer(tap)
        } else {
            view.removeGestureRecognizer(tap)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
