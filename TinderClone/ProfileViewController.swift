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
import ProgressHUD
class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var bioTextCaption: UITextView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var FrinedsNum: UILabel!
    @IBOutlet weak var fbPic: UIImageView!
    var selectedPicture: UIImage?
    var dict : NSDictionary!
   // var dict2 : NSDictionary!

    @IBOutlet weak var gallery1: UIImageView!
    @IBOutlet weak var gallery2: UIImageView!
    @IBOutlet weak var addPhoto: UIImageView!
    
    @IBAction func clearrAllBtn(_ sender: Any) {
        clearAll()
    }
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.handleImageChosen) )
        
        addPhoto?.addGestureRecognizer(tap)
        addPhoto?.isUserInteractionEnabled=true

        fbPic.layer.cornerRadius = fbPic.frame.size.width/2
        fbPic.clipsToBounds = true
        
        let loginButton: FBSDKLoginButton = FBSDKLoginButton()
        loginButton.delegate = self
        view.addSubview(loginButton)
        loginButton.frame = CGRect(x: 18, y: 630, width: view.frame.width - 32, height: 50)
        
      
        getFBinfo()
        
      
       getpicture()
    
       
    }

    func getpicture(){
        let userID: String = Auth.auth().currentUser!.uid

        Database.database().reference().child("posts").child(userID).observe(.value, with: { (snapshot) in
            
            
//            let dictionary = snapshot.value as? [String: Any]
//            let picURL = dictionary?["photoURL"] as? String
//            let picURL2 = dictionary?["photoURL2"] as? String
            
            if snapshot.value is NSNull {
                print("######")
                self.gallery1.image = UIImage(named: "gallery-icon")
                self.gallery2.image = UIImage(named: "gallery-icon")
                self.bioTextCaption.text = ""
            }
            else{
            if let dictionary = snapshot.value as? [String: Any]{
            let bio = dictionary["caption"] as? String
            let picURL = dictionary["photoURL"] as? String
            let picURL2 = dictionary["photoURL2"] as? String
            self.bioTextCaption.text = bio
                
          
            let storage = Storage.storage()
            let photoRef = storage.reference(forURL: picURL!)
            // Fetch the download URL
            photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    self.gallery1.image = image
                }
            }
            
            if picURL2 == ""{
                print("upload second photo to view it")
            }
            else{
               let  photoRef2 = storage.reference(forURL: picURL2!)
                // Fetch the download URL
                photoRef2.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        self.gallery2.image = image
                    }
                }

            }
            }
            }
        }
        )
        

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

    
        func getFBinfo(){
            var ref: DatabaseReference!
            ref = Database.database().reference()
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
                    
                    
                    newPostReference.setValue(["Name":username,"Gender":gender,"userFIRid": userID,"email": email,"FB result":result], withCompletionBlock: {
                        (error, ref) in
                        if error != nil {
                            //ProgressHUD.showError
                            print(error!.localizedDescription)
                        }
                        else{
                            self.genderLabel.text=gender
                            Database.database().reference().child("users").child(userID).child("FB result").child("age_range").child("min").observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                var myval = snapshot.value! as! Int
                                var mystring = "\(myval)"
                                print(mystring)
                                self.ageLabel.text = mystring
                            
                            })
                            Database.database().reference().child("users").child(userID).child("FB result").child("friends").child("summary").child("total_count").observeSingleEvent(of: .value, with: { (snapshot) in
                                var myval2 = snapshot.value! as! Int
                                var mystring2 = "\(myval2)"
                                print(mystring2)
                                self.FrinedsNum.text = mystring2
                            })
                            
                            //ProgressHUD.showSuccess("Success")
                            //self.clean()
                            //self.tabBarController?.selectedIndex=0
                        }
                    })
                    
                    
                    print("$%$%$%$%$%$%$%$%$%$%")
                    
                }
            })
        }
       
    }
    
    func handleImageChosen(){
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func dissmiss_OnClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func clearAll(){
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let userID: String = Auth.auth().currentUser!.uid
        let newPostId = postReference.childByAutoId()
        let newPostReference = postReference.child(userID)
        let emptyStr = NSNull()
        newPostReference.setValue(["caption":emptyStr,"photoURL":emptyStr,"photoURL2":emptyStr], withCompletionBlock: {
            (error, ref) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            }
            else{
                ProgressHUD.showSuccess("Success")
                
            }
        })

    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        print("did finish picking")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedPicture = image
            ProgressHUD.show("Waiting...", interaction: false)
            
            if let userPhotoimg =  self.selectedPicture, let imageData = UIImageJPEGRepresentation(userPhotoimg, 0.1){
                let postId = NSUUID().uuidString
                let storageRef = Storage.storage().reference(forURL: "gs://tinderclone-e519e.appspot.com/" ).child("photos").child(postId)
                storageRef.putData(imageData, metadata: nil, completion: {(metadata, error) in
                    if error != nil{
                        ProgressHUD.showError(error?.localizedDescription)
                        return
                    }
                    
                    let postUrl = metadata?.downloadURL()?.absoluteString
                    self.sendDataToDatabase(postUrl: postUrl!)
                    
                })
                
            } else{
                ProgressHUD.showError("Please select a Photo")
                print("Photos cant be empty")
            }

        }
        
        print(info)
        //  profilePictureContainer.image = infoPhoto
        dismiss(animated: true, completion: nil)
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func sendDataToDatabase(postUrl:String){
        //   let userid =
        let ref = Database.database().reference()
        let postReference = ref.child("posts")
        let userID: String = Auth.auth().currentUser!.uid
        let newPostId = postReference.childByAutoId()
        var newPostReference = postReference.child(userID)
     
        
        let database = Database.database().reference()
        database.child("posts").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            
            if snapshot.hasChild( Auth.auth().currentUser!.uid)
            {
                newPostReference = postReference.child(userID) //.child("photoURL2")
                newPostReference.updateChildValues(["photoURL2":postUrl,"caption":self.bioTextCaption.text])
                ProgressHUD.showSuccess("Success")

            }
            else{
                var emptyValue = ""
                newPostReference.setValue(["photoURL": postUrl,"photoURL2":emptyValue,"caption":self.bioTextCaption.text!,"UserID":userID], withCompletionBlock: {
                    (error, ref) in
                    if error != nil {
                        ProgressHUD.showError(error!.localizedDescription)
                    }
                    else{
                        ProgressHUD.showSuccess("Success")
                        
                    }
                })
            }
      })
    
        
    }

    
}

