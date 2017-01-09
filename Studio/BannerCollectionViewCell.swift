//
//  BannerCollectionViewCell.swift
//  Studio
//
//  Created by Felicity Johnson on 1/9/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit

class BannerCollectionViewCell: UICollectionViewCell {
    
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
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        
    }
    
    private func configureView() {
        
        // avatarImage Config
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView = UIImageView(frame: CGRect(x: 20, y: 45, width: 40, height: 40))
        avatarImageView.contentMode = .scaleAspectFill
        self.addSubview(avatarImageView)
        
        // usernameLabel Config
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        usernameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 0).isActive = true
        usernameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Helvetica", size: 14.0)
        
        // ageGenderLocation Config
        self.addSubview(ageGenderLocation)
        ageGenderLocation.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLocation.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20).isActive = true
        ageGenderLocation.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 0).isActive = true
        ageGenderLocation.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        ageGenderLocation.textAlignment = .center
        ageGenderLocation.font = UIFont(name: "Helvetica", size: 14.0)
        
        // bpmLabel Config
        self.addSubview(bpmLabel)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.topAnchor.constraint(equalTo: ageGenderLocation.bottomAnchor, constant: 20).isActive = true
        bpmLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 0).isActive = true
        bpmLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        bpmLabel.textAlignment = .center
        bpmLabel.font = UIFont(name: "Helvetica", size: 14.0)

    }
    
    func populateUserInfo() {
        guard let username = user?.username else { print("no username"); return }
        guard let bpm = user?.bpm else { print("no bpm"); return }
        guard let age = user?.age else { print("no age"); return }
        guard let gender = user?.gender else { print("no gender"); return }
        guard let location = user?.location else { print("no location"); return }
        
        avatarImageView.image = UIImage(named: "AvatarImage")
        usernameLabel.text = username
        ageGenderLocation.text = "\(age) / \(gender) / \(location)"
        bpmLabel.text = bpm
    }

}
