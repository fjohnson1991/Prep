//
//  BannerView.swift
//  Studio
//
//  Created by Felicity Johnson on 1/8/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit

class BannerView: UIView {
    
    var bpmLabel = UILabel()
    var usernameLabel = UILabel()
    var ageLabel = UILabel()
    var genderLabel = UILabel()
    var locationLabel = UILabel()
    
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
        Bundle.main.loadNibNamed("BannerView", owner: self, options: nil)
        backgroundColor = UIColor.clear
        
        // bpmLabel Config
        self.addSubview(bpmLabel)
        bpmLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // usernameLabel Config
        
        
        // ageLabel Config
        
        
        
        // genderLabel Config
        
        
        
        // locationLabel Config
        
        
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
    
    }
    
}
