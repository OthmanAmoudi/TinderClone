//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 25/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 18, y: 630, width: view.frame.width - 32, height: 50)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    
    

}
