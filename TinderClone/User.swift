//
//  User.swift
//  TinderClone
//
//  Created by Othman Mashaab on 28/05/2017.
//  Copyright © 2017 Othman Mashaab. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class User{
    
    var uid: String?
    var name: String?
    var age: String?
    var gender: String?
    var caption: String?
    var photoURL: String?
    
    init?(snapshot: DataSnapshot){
        
        self.uid = snapshot.key
            if let dictionary = snapshot.value as? [String: Any]{
                let caption = dictionary["caption"] as? String
                let age = dictionary["age"] as? String
                let name = dictionary["name"] as? String
                let gender = dictionary["gender"] as? String
                let picURL = dictionary["photoURL"] as? String
                let picURL2 = dictionary["photoURL2"] as? String
            
            
            }
        }
    }
