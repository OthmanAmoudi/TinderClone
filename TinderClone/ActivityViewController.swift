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
    
    let userID: String = Auth.auth().currentUser!.uid
    var ref: DatabaseReference!
    let dataBaseRef = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        getMatch()
        
        
    }
    
    func getMatch(){
        
    }

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
