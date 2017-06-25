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
    
    init(uidString:String,nameString:String,ageNum:String,genderString:String,captionString:String,photoURLString:String){
        uid = uidString
        name = nameString
        age = ageNum
        gender = genderString
        caption = captionString
        photoURL = photoURLString
    }
    }
