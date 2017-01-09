//
//  BannerView.swift
//  Studio
//
//  Created by Felicity Johnson on 1/8/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit

class BannerView: UIView {

    var avatarImageView = UIImageView()
    var usernameLabel = UILabel()
    var ageLabel = UILabel()
    var genderLabel = UILabel()
    var locationLabel = UILabel()
    var bpmLabel = UILabel()
    var ageGenderLocation = UILabel()

    var user: User? {
        didSet {
            populateUserInfo()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    private func commonInit() {
        // avatarImage Config
        self.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        
        // usernameLabel Config
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Helvetica", size: 12.0)

        // ageGenderLocation Config
        self.addSubview(ageGenderLocation)
        ageGenderLocation.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLocation.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8).isActive = true
        ageGenderLocation.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
        ageGenderLocation.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        ageGenderLocation.textAlignment = .center
        ageGenderLocation.font = UIFont(name: "Helvetica", size: 12.0)
        
        // bpmLabel Config
        self.addSubview(bpmLabel)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.topAnchor.constraint(equalTo: ageGenderLocation.bottomAnchor, constant: 8).isActive = true
        bpmLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
        bpmLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        bpmLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        bpmLabel.textAlignment = .center
        bpmLabel.font = UIFont(name: "Helvetica", size: 12.0)
    }
}


// MARK: - Configure View
extension BannerView {
    
    func constrainToEdges(to view: UIView) {
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func populateUserInfo() {
        guard let username = user?.username else { print("no username"); return }
        guard let bpm = user?.bpm else { print("no bpm"); return }
        guard let age = user?.age else { print("no age"); return }
        guard let gender = user?.gender else { print("no gender"); return }
        guard let location = user?.location else { print("no location"); return }
        
        avatarImageView.image = UIImage(named: "StudioIcon")
        usernameLabel.text = username
        ageGenderLocation.text = "\(age) / \(gender) / \(location)"
        bpmLabel.text = bpm
    }
}
