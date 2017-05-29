//
//  MatchesViewController.swift
//  TinderClone
//
//  Created by Othman Mashaab on 25/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
class MatchesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    
    var postCap = [String]()
    var postPicurl = [String]()
    var postPic = [UIImage]()
    
    // var senderId: String
  //  var senderDisplayName: String
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
observeUsers()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    func observeUsers(){
        Database.database().reference().child("users").observe(.childAdded, with: {(usersSnap) in
            Database.database().reference().child("users").child(usersSnap.key).observe(.value, with: {(aUserSnap) in
        
            if let dict = aUserSnap.value as? [String: Any]{
                print("@@@@@\(dict)")
                let username = dict["name"] as? String
             //   let avatarUrl = dict["profileUrl"] as! String
                self.postCap.append(username!)
                self.tableView.reloadData()
            }
            
        })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {

    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ChatView", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postCap.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = postCap[indexPath.row]
        return cell
    }

}
