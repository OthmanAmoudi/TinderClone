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
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController , FBSDKLoginButtonDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 18, y: 650, width: view.frame.width - 32, height: 50)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil{
            goToProfile()
        }
    }
    
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    func goToProfile(){
        performSegue(withIdentifier: "ToHomeTabBarSegue", sender: nil)
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        loginButton.isHidden = true

        if let error = error {
            print(error.localizedDescription)
            loginButton.isHidden = false

            return
        }
        else if (result.isCancelled){
            
            loginButton.isHidden = false

        }
        
        else{
        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
          //let username = user?.displayName
          //  print("@@@loggied User Name:\(username)")
            self.goToProfile()
        }
    }
    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    

}

}
