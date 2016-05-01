//
//  ViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/26/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "user_events", "user_friends", "user_about_me", "user_about_me", "user_photos", "user_tagged_places"]
        
        loginButton.center = self.view.center
        
        self.view.addSubview(loginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

