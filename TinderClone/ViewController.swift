//
//  ViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 25/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
class ViewController: UIViewController , FBSDKLoginButtonDelegate {
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        dismiss(animated: true, completion: nil)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        var loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 18, y: 650, width: view.frame.width - 32, height: 50)
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        else{
        goToProfile()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func goToProfile(){
        performSegue(withIdentifier: "ToHomeTabBarSegue", sender: nil)
    }

}


