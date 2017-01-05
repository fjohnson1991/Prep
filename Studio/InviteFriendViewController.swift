//
//  InviteFriendViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/2/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import Branch

class InviteFriendViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func inviteFriend(_ sender: Any) {
        
        //branch universal object = container Branch uses to organize & track app's content. 
        
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
        branchUniversalObject.title = "Studio"
        branchUniversalObject.contentDescription = "Join an exercise class"
        branchUniversalObject.imageUrl = "https://drive.google.com/uc?id=0B4g_ZeUOQsvxU3JZcTQxVHJDa3M"
        
        let linkProperties: BranchLinkProperties = BranchLinkProperties()
        linkProperties.feature = "sharing"
        linkProperties.addControlParam("$ios_url", withValue: "com.Studio.DeepLink")
        
        branchUniversalObject.getShortUrl(with: linkProperties) { (url, error) in
            if error == nil {
                print("got my Branch link to share: %@", url)
            }
        }
        
        branchUniversalObject.showShareSheet(with: linkProperties, andShareText: "Come workout with me at Studio!", from: self) { (activityType, completed) in
        }
    }
}

