//
//  ActivityViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 25/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class ActivityViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ageRangeLabel: UILabel!
    @IBOutlet weak var matchPhoto: UIImageView!
    @IBOutlet weak var bioText: UILabel!
    
    var matches = [User]()
    var mymatches = [String]()
    var keys = [String]()
    var keys2 = [Int]()
    var randumUserKey: String = ""
    var counterKey: Int = 0
    var counter = 0
    
    let userID: String = Auth.auth().currentUser!.uid
    var ref: DatabaseReference!
    let dataBaseRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let mylabel = UILabel(frame:CGRect(x: self.view.bounds.width/2-100, y: self.view.bounds.height/2-50, width: 200, height: 100))
        
           // mylabel.text = "DRAGEER"
        
        //    mylabel.textAlignment = NSTextAlignment.center
        
         //   view.addSubview(mylabel)
        
        let geture = UIPanGestureRecognizer(target: self, action: #selector(self.wasDragged(gestureRecognizer:)))
        
        matchPhoto.addGestureRecognizer(geture)
        
        getMatch()
        
        matchPhoto.isUserInteractionEnabled=true
        
        //loadUsers()
        //nameLabel.text = matches
    }
    func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        let translation = gestureRecognizer.translation(in: view)
        //print(translation)
        let mylabel = gestureRecognizer.view!
        mylabel.center = CGPoint(x: self.view.bounds.width/2 + translation.x, y: self.view.bounds.height/2 + translation.y)
        
        if gestureRecognizer.state == UIGestureRecognizerState.ended{
            if mylabel.center.x < 100 {
                print("Disliked")
                getMatch()
            }
            else if mylabel.center.x > self.view.bounds.width - 100{
                print("Liked")
                getMatch()
            }
            mylabel.center = CGPoint(x: self.view.bounds.width/2, y: self.view.bounds.height/2)
        }
        
        
    }
    @IBOutlet weak var likeBtn: UIButton!
    
    @IBAction func likeDidPressed(_ sender: Any) {
        print("\(nameLabel.text!) liked")
        getMatch()
    }
    
    @IBAction func disLikedDidPress(_ sender: Any) {
        print("\(nameLabel.text!) Disliked")
        getMatch()
    }
    
    @IBAction func superLiked(_ sender: UIPanGestureRecognizer) {
        print("\(nameLabel.text!) super liked")
        getMatch()
    }
//    
//        let matchPhoto = (sender as AnyObject).view!
//        let point = (sender as AnyObject).translation(in:view)
//        matchPhoto.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
//        UIView.animate(withDuration: 0.2) {
//            matchPhoto.center = self.view.center
//        }
//        
//        print("Moving...")
//    
  
//    func loadUsers(){
//        
//        let userID: String = Auth.auth().currentUser!.uid
//        Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
//            
//            for a in ((snapshot.value as AnyObject).allKeys)!{
//                self.keys.append(a as! String)
//                print(a)
//            }
//            
//            print(self.keys)
//            
//            
//            func generateNum(){
//            var randomNum = Int(arc4random_uniform(UInt32(self.keys.count)))
//            self.randumUserKey = self.keys[randomNum]
//            print(self.randumUserKey)
//            }
//            
//            generateNum()
//            
//         //   var dictionary = snapshot.value as? [String:AnyObject]
//
//           // for(_,value) in dictionary{
//            //    if (snapshot.key as? String) == self.randumUserKey {
//                               // print("TTT")
//                   // print(name, "was liked by",likedby)
//            if let dictionary = snapshot.value as? [String: Any]{
//                var likedby = dictionary["Liked By"] as! String
//                let name = dictionary["name"] as! String
//                let age = dictionary["age"] as! String
//                let caption = dictionary["caption"] as! String
//                let picURL = dictionary["photoURL"] as! String
//                let gender = dictionary["gender"] as! String
//                
//                let myusers = User(uidString: snapshot.key, nameString: name, ageNum: age, genderString: gender, captionString: caption, photoURLString: picURL)
//                    
//                    self.matches.append(myusers)
//                    print("||||||")
//            
//            for s in self.matches{
//                print(self.matches[0].name!)
//            }
//
//                    let storage = Storage.storage()
//                    let photoRef = storage.reference(forURL: picURL)
// 
//                    //Fetch the download URL
//                    photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                        } else {
//                            // Data for "images/island.jpg" is returned
//                            let image = UIImage(data: data!)
//                            self.matchPhoto.image = image
//                        }
//                    }
//
//                    self.nameLabel.text = name
//                    self.genderLabel.text = gender
//                    let ageStr = "\(age)"
//                    self.ageRangeLabel.text = age
//                    self.bioText.text = caption
//
//                
//            }
//        })
//        
//       
//    }
    
    
        func getMatch(){
            let userID: String = Auth.auth().currentUser!.uid
            
            // im trying to split this closure because everytime its duplicating ... the arrays become 8 then 16 then 32 when like button is pressed ! 
            
            //to get each key and then view it to the user
            Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
                for a in ((snapshot.value as AnyObject).allKeys)!{
                    self.keys.append(a as! String)
                  //  self.keys2.append(a as! Int)
                   // print(a)
                    
                }
                print("KKEeeys")
                print(self.keys)
                
                // to show users from 1 to 4 ... i only have four users in my "post" database firebase
                func generateNum(){
                  //  var randomNum = Int(arc4random_uniform(UInt32(self.keys.count)))
                  //  self.randumUserKey = self.keys[randomNum]
                  //  print("the lucky one is: \(self.randumUserKey)")
                    
                    
                    self.randumUserKey = self.keys[self.counter]
                    self.counter += 1
                    
                    var targetNum = self.keys.count
                    if self.counter == targetNum {
                        self.counter = 0
                        print("counter == 0 now!")
                    }
                    // to teset
                   print("TARGET:\(targetNum)the number is \(self.counter) and total of array elements are: \(self.keys.count)")
                }
                
                generateNum()
                
                
                Database.database().reference().child("posts").child(self.randumUserKey).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let dictionary = snapshot.value as? [String:AnyObject]
                    
//                    let age2 = dictionary["age"] as? String
//                    let caption2 = dictionary["caption"] as? String
//                    let gender2 = dictionary["gender"] as? String
//                    let name2 = dictionary["name"] as? String
//                    let picURL2 = dictionary["photoURL"] as? String
//                    
                 //   for(_,value) in dictionary!{
//                        if (snapshot.value["Liked By"] as? String) != nil{
//                            print("Fuked up shit is here")
//                            generateNum()
//                        }
//                        else{
                            if let dictionary = snapshot.value as? [String: Any]{
                                
                                let likedby = dictionary["Liked By"] as? String
                                let age = dictionary["age"] as? String
                                let caption = dictionary["caption"] as? String
                                let gender = dictionary["gender"] as? String
                                let name = dictionary["name"] as? String
                                let picURL = dictionary["photoURL"] as? String
                                
                                
                                let storage = Storage.storage()
                                let photoRef = storage.reference(forURL: picURL!)
                                // Fetch the download URL
                                photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                    } else {
                                        // Data for "images/island.jpg" is returned
                                        let image = UIImage(data: data!)
                                        self.matchPhoto.image = image
                                    }
                                }
                                
                                print("||||||")
                                
                                self.nameLabel.text = name
                                self.genderLabel.text = gender
                                // let ageStr = "\(age)"
                                self.ageRangeLabel.text = age
                                self.bioText.text = caption
                                print("my name is: \(name!) and im: \(age!) years old and was liked by\(likedby)")
                        
                    }
                })
                
            })
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}





//            Database.database().reference().child("posts").observe(.childAdded, with: {(usersSnap) in
//                Database.database().reference().child("posts").child(usersSnap.key).observe(.value, with: {(aUserSnap) in
//                   // print("%%%%%%%%%%%%%%")
//                    if let dictionary = usersSnap.value as? [String: Any]{
//                        let age = dictionary["age"] as? String
//                        let caption = dictionary["caption"] as? String
//                        let gender = dictionary["gender"] as? String
//                        let name = dictionary["name"] as? String
//                        let picURL = dictionary["photoURL"] as? String
//                        let storage = Storage.storage()
//                        let photoRef = storage.reference(forURL: picURL!)
//
//                        // Fetch the download URL
//                        photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
//                            if let error = error {
//                                print(error.localizedDescription)
//                            } else {
//                                // Data for "images/island.jpg" is returned
//                                let image = UIImage(data: data!)
//                                self.matchPhoto.image = image
//                            }
//                        }
//
//                        let myusers = User(uidString: usersSnap.key, nameString: name!, ageNum: age!, genderString: gender!, captionString: caption!, photoURLString: picURL!)
//
//                      //  self.matches.append(myusers)
//                        self.matches.insert(User(uidString:usersSnap.key, nameString:name!, ageNum: age!, genderString: gender!, captionString: caption!, photoURLString: picURL!), at: 0)
//                        print("||||||")
//                        print(self.matches.capacity)
//                        print("\(self.matches[0].name!) has \(self.matches[0].uid!)")
//
//                        self.nameLabel.text = name
//                        self.genderLabel.text = gender
//                       // let ageStr = "\(age)"
//                        self.ageRangeLabel.text = age
//                        self.bioText.text = caption
//                        print("my name is: \(name!) and im: \(age!) years old")
//
//                    }
//                    })
//                })
