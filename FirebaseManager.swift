//
//  FirebaseManager.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/19/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class FirebaseManager: NSObject {
    static let sharedInstance = FirebaseManager()
    let databaseRef = Database.database().reference()
    let userDatabaseRef = Database.database().reference().child("users")
    let stepStatisticRef = Database.database().reference().child("steps")
    let followingRef = Database.database().reference().child("following")
    let followerRef =
        Database.database().reference().child("followers")
    
}

