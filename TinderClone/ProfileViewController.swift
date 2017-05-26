//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 25/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FBSDKCoreKit
class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    var dict : NSDictionary!
    
    @IBOutlet weak var fbPic: UIImageView!
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            print("Did Logged OUT FROm FIREBASEEEEE Server")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbPic.layer.cornerRadius = fbPic.frame.size.width/2
        fbPic.clipsToBounds = true
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
       // self.ref.child("users").child(user.uid).setValue(["username": username])
        if let user = Auth.auth().currentUser{
            let photoURL = user.photoURL
            let username = user.displayName
            self.navigationItem.title = username
            let data = NSData(contentsOf: photoURL!)
            fbPic.image = UIImage(data: data! as Data)
            
            
            let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"gender, name,email, birthday,friends,age_range"])
            
       
            graphRequest.start(completionHandler: { (connection, result, error) -> Void in
                
                if ((error) != nil){
                    print("Error: \(error)")
                }
                else {
                    self.dict = result as! NSDictionary
                    var username = self.dict["name"] as? String
                    var gender = self.dict["gender"] as? String
                    //var age = self.dict["age_range"] as? String
                    //var friends = self.dict["friends"] as? [String]
                    var email = self.dict["email"] as? String
                    
                    let ref = Database.database().reference()
                    let postReference = ref.child("users")
                    let userID: String = Auth.auth().currentUser!.uid
                    let newPostId = postReference.childByAutoId()
                    let newPostReference = postReference.child(userID)
                    
               //     if new
            newPostReference.setValue(["Name":username,"Gender":gender,"userFIRid": userID,"email": email,"FB result":result], withCompletionBlock: {
                        (error, ref) in
                        if error != nil {
                            //ProgressHUD.showError
                            print(error!.localizedDescription)
                        }
                        else{
                            //ProgressHUD.showSuccess("Success")
                            //self.clean()
                            //self.tabBarController?.selectedIndex=0
                        }
                    })


                    print("$%$%$%$%$%$%$%$%$%$%")
                    
                }
            })
        }
        else{
            
        }
        
//        let credential = FacebookAuthProvider.credential(withAccessToken:FBSDKAccessToken.current().tokenString)
//        Auth.auth().signIn(with: credential) { (user, error) in
//            let proPicURL = user?.photoURL
//            // Create a reference to the file you want to download
//            let storageRef = Storage.storage().reference(forURL: "gs://tinderclone-e519e.appspot.com/")
//            let islandRef = storageRef
//            
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
        
    
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
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
