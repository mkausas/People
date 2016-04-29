//
//  LoginViewController.swift
//  People
//
//  Created by Martynas Kausas on 4/28/16.
//  Copyright © 2016 Marty Kausas. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "user_events", "user_friends", "user_about_me", "user_about_me", "user_photos", "user_tagged_places"]
        
        loginButton.center = self.view.center
        
        self.view.addSubview(loginButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.dismissViewControllerAnimated(true) {
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
