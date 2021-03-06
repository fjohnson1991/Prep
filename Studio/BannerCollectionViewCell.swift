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
    
    fileprivate func configureView() {
        //AvatarImage Config
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView = UIImageView(frame: CGRect(x: 20, y: 35, width: 40, height: 40))
        avatarImageView.contentMode = .scaleAspectFill
        self.addSubview(avatarImageView)
        
        //UsernameLabel Config
        self.addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        usernameLabel.textAlignment = .center
        usernameLabel.font = UIFont(name: "Helvetica", size: 15.0)
        usernameLabel.textColor = UIColor.white
        
        //AgeGenderLocation Config
        self.addSubview(ageGenderLocation)
        ageGenderLocation.translatesAutoresizingMaskIntoConstraints = false
        ageGenderLocation.heightAnchor.constraint(equalToConstant: 15).isActive = true
        ageGenderLocation.textAlignment = .center
        ageGenderLocation.font = UIFont(name: "Helvetica", size: 12.0)
        ageGenderLocation.textColor = UIColor.white
        
        //BpmLabel Config
        self.addSubview(bpmLabel)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        bpmLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        bpmLabel.font = UIFont(name: "Helvetica", size: 12.0)
        bpmLabel.textColor = UIColor.white
        
        //Stack view Config
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
        
        //Stack view constraints
        stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        stackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8).isActive = true
    }
    
    private func convertAge(with age: String) -> String {
        var finalAge = String()
        if let firstLetter = age.characters.first {
            finalAge = "\(firstLetter)0's"
        }
        return finalAge
    }
    
    func populateUserInfo() {
        guard let username = user?.username else { print("no username"); return }
        guard let bpm = user?.bpm else { print("no bpm"); return }
        guard let age = user?.age else { print("no age"); return }
        let ageString = "\(age)"
        guard let gender = user?.gender else { print("no gender"); return }
        guard let location = user?.location else { print("no location"); return }
        
        avatarImageView.image = UIImage(named: "AvatarImage")
        usernameLabel.text = username
        ageGenderLocation.text = "\(convertAge(with: ageString)) / \(gender) / \(location)"
        
        //Bpm and image text config
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "HeartrateChart")
        let attachmentString = NSAttributedString(attachment: attachment)
        let bpmString = NSAttributedString(string: " \(bpm)")
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        myString.append(bpmString)
        bpmLabel.attributedText = myString
        bpmLabel.textAlignment = .center
        bpmLabel.attributedText = myString
    }
}
