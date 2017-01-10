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
        
        self.layer.backgroundColor = UIColor.black.withAlphaComponent(0.7).cgColor
        
        // avatarImage Config
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView = UIImageView(frame: CGRect(x: 20, y: 35, width: 40, height: 40))
        avatarImageView.contentMode = .scaleAspectFill
        self.addSubview(avatarImageView)
        
        // usernameLabel Config
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Helvetica", size: 15.0)
        usernameLabel.textColor = UIColor.white
        
        // ageGenderLocation Config
        self.addSubview(ageGenderLocation)
        ageGenderLocation.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLocation.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ageGenderLocation.textAlignment = .center
        ageGenderLocation.font = UIFont(name: "Helvetica", size: 12.0)
        ageGenderLocation.textColor = UIColor.white
        
        // bpmLabel Config
        self.addSubview(bpmLabel)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        bpmLabel.textAlignment = .center
        bpmLabel.font = UIFont(name: "Helvetica", size: 12.0)
        bpmLabel.textColor = UIColor.white
        
        // stack view Config
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 12.0
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(ageGenderLocation)
        stackView.addArrangedSubview(bpmLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false;
        self.addSubview(stackView)
        
        // stack view constraints
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
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
