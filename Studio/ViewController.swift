//
//  ViewController.swift
//  Studio
//
//  Created by Felicity Johnson on 1/2/17.
//  Copyright © 2017 FJ. All rights reserved.
//

import UIKit
import Branch

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func inviteFriend(_ sender: Any) {
        
        //branch universal object = container Branch uses to organize & track app's content. 
        
        let branchUniversalObject: BranchUniversalObject = BranchUniversalObject(canonicalIdentifier: "item/12345")
        branchUniversalObject.title = "Studio"
        branchUniversalObject.contentDescription = "Join an exercise class"
        branchUniversalObject.imageUrl = "file:///Users/felicityjohnson/Development%20Projects/Studio/Studio/Assets.xcassets/StudioIcon.imageset/image00-1.png"
        
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
        
        print(branchUniversalObject)
        
    }

}

