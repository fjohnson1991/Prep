//
//  FirebaseMethods.swift
//  Studio
//
//  Created by Felicity Johnson on 1/7/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseMethods {
    
    //MARK: - Sign Up & Log In funcs
    static func signInButton(email: String, password: String, completion: @escaping (Bool) -> () ) {
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    static func signUpButton(email: String, password: String, name: String, username: String, completion: @escaping (Bool) -> () ) {
        
        let ref = FIRDatabase.database().reference().root
        var boolToPass = false
        
        if email != "" && password != "" {
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    let userDictionary = ["email": email, "name": name, "username": username, "userUniqueKey": (user?.uid)!, "avatarIcon": "no image", "recentBPM": "none"]
                    
                    ref.child("users").child((user?.uid)!).setValue(userDictionary)
                    boolToPass = true
                    completion(boolToPass)
                    
                } else {
                    print(error?.localizedDescription ?? "")
                    boolToPass = false
                    completion(boolToPass)
                }
            })
        }
    }
    
    //MARK: - Remove previous "current class" BPM from Firebase
    class func removePreviousCurrentClassData() {
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        let currentClassRef = FIRDatabase.database().reference().child("users").child(currentUserID).child("currentClass")
        
        currentClassRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                print("no BPM data")
            } else {
                currentClassRef.removeValue()
            }
        })
        
        
        // included SOLELY FOR DUMMY DATA:
        let userOneRef = FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa53").child("currentClass")
        userOneRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                print("no BPM data")
            } else {
                userOneRef.removeValue()
            }
        })
        
        let userTwoRef = FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa54").child("currentClass")
        userTwoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                print("no BPM data")
            } else {
                userTwoRef.removeValue()
            }
        })
        
        let userThreeRef = FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa55").child("currentClass")
        userThreeRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                print("no BPM data")
            } else {
                userThreeRef.removeValue()
            }
        })
    }
    
    //MARK: - Send BPM to Firebase
    class func sendBPMToFirebase(with exerciseClassUniqueKey: String, bpm: String) {
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        let recentClassRef = FIRDatabase.database().reference().child("users").child(currentUserID)
        let currentClassRef = FIRDatabase.database().reference().child("users").child(currentUserID).child("currentClass")
        let previousClassRef = FIRDatabase.database().reference().child("users").child(currentUserID).child("previousClasses").child(exerciseClassUniqueKey).child("BPM")
        let bpmKey = FIRDatabase.database().reference().childByAutoId().key
        let timeStamp = Date().timeIntervalSince1970.description
        let valuesToUpdate = ["timestamp": timeStamp, "value" : "\(bpm)"]
        
        currentClassRef.updateChildValues([bpmKey: valuesToUpdate])
        recentClassRef.updateChildValues(["recentBPM" : "\(bpm)"])
        //previousClassRef.updateChildValues([bpmKey : ["timestamp": timeStamp, "value" : "\(bpm)"]])
        
        // included SOLELY FOR DUMMY DATA:
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa53").child("currentClass").updateChildValues([bpmKey: valuesToUpdate])
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa53").updateChildValues(["recentBPM" : "\(bpm)"])
        
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa54").child("currentClass").updateChildValues([bpmKey: valuesToUpdate])
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa54").updateChildValues(["recentBPM" : "\(bpm)"])
        
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa55").child("currentClass").updateChildValues([bpmKey: valuesToUpdate])
        FIRDatabase.database().reference().child("users").child("eWl3v4c6snTJY0O65zUPyu9ypa55").updateChildValues(["recentBPM" : "\(bpm)"])
        
    }
    
    //MARK: - Retrive BPM from Firebase
    class func getCurrentUsersLiveUpdateBPM(with completion: @escaping (String) -> Void) {
        guard let currentUserID = FIRAuth.auth()?.currentUser?.uid else { return }
        let currentClassRef = FIRDatabase.database().reference().child("users").child(currentUserID).child("recentBPM")
        
        currentClassRef.observe(.value, with: { (snapshot) in
            guard let bpm = snapshot.value as? String else {return}
            completion(bpm)
        })
    }
    
    //MARK: - Retrive users in current class from Firebase
    class func retrieveAllUsersInClass(with exerciseClassUniqueKey: String, completion: @escaping ([User]) -> Void) {
        let userClassRef = FIRDatabase.database().reference().child("users")
        var users = [User]()
        
        userClassRef.observe(.value, with: { (snapshot) in
            if !snapshot.hasChildren() {
                print("no users")
            } else {
                guard let snapshotValue = snapshot.value as? [String: Any] else { return }
                for snap in snapshotValue {
                    guard
                        let userInfo = snap.value as? [String: Any],
                        let name = userInfo["name"] as? String,
                        let username = userInfo["username"] as? String,
                        let email = userInfo["email"] as? String,
                        let userUniqueKey = userInfo["userUniqueKey"] as? String,
                        let gender = userInfo["gender"] as? String,
                        let age = userInfo["age"] as? String,
                        let location = userInfo["location"] as? String,
                        let recentBPM = userInfo["recentBPM"] as? String
                        else { return }
                    
                    let user = User(name: name, userUniqueKey: userUniqueKey, previousClasses: [], bpm: recentBPM, username: username, gender: gender, age: Int(age)!, location: location)
                    users.append(user)
                    
                    if users.count == snapshotValue.count {
                        completion(users)
                    }
                }
            }
        })
    }
}
