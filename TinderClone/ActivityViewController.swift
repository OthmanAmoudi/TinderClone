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
    
    let userID: String = Auth.auth().currentUser!.uid
    var ref: DatabaseReference!
    let dataBaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        //getMatch()
        loadUsers()
        
    }
    
    
    func loadUsers(){
        let userID: String = Auth.auth().currentUser!.uid
       Database.database().reference().child("posts").observe(.childAdded, with: {(usersSnap) in
            
            Database.database().reference().child("posts").child(usersSnap.key).observe(.value, with: {(aUserSnap) in
                print("%%%%%%%%%%%%%%")
                if let dictionary = usersSnap.value as? [String: Any]{
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
                    self.nameLabel.text = name
                    self.genderLabel.text = gender
                    let ageStr = "\(age)"
                    self.ageRangeLabel.text = ageStr
                    self.bioText.text = caption
                    print(caption)
                    
                    
                }

                //}
            })
        })
    }

    
//    func getMatch(){
//        let userID: String = Auth.auth().currentUser!.uid
//        
//        Database.database().reference().child("posts").observe(.value, with: { (snapshot) in
//            for childSnap in  snapshot.children.allObjects {
//                let snap = childSnap as! DataSnapshot
//                if let snapshotValue = snapshot.value as? NSDictionary, let snapVal = snapshotValue[snap.key] as? AnyObject {
//                   // print("val" , snapVal)
//                   
//                    if let dictionary = snapVal as? [String: Any]{
//                    let myUserID = dictionary["UserID"] as? String
//                    let caption = dictionary["caption"] as? String
//                    let picURL = dictionary["photoURL"] as? String
//                        
//                        print(caption)
////                    let storage = Storage.storage()
////                    let photoRef = storage.reference(forURL: picURL!)
////                                        // Fetch the download URL
////                    photoRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
////                    if let error = error {
////                    print(error.localizedDescription)
////                    } else {
////                                                // Data for "images/island.jpg" is returned
////                    let image = UIImage(data: data!)
////                                            // self.gallery1.image = image
////                            }
////                        }
//                }
//                    
//                    
//                    
//                }
//            }
//        })
//
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
