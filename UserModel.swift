//
//  UserModel.swift
//  fitnessPro
//
//  Created by Nathan Chen on 5/28/17.
//  Copyright © 2017 Nathan Chen. All rights reserved.
//

import UIKit
import Firebase
class UserModel: NSObject {
    var email:String?
    var name:String?
    var totalStep:Int?
    var uid:String?
    var photoURL:URL?
    init(withSnap snapshot:DataSnapshot) {
        uid = snapshot.key
        guard let dict = snapshot.value as?[String : Any] else { return  }
        name = dict["name"] as? String
        if let step = dict["totalStep"] as? Int{
            self.totalStep = step
        }else{
            self.totalStep = 0
        }
        guard let urlString = dict["photoURL"] as? String else { return  }
        photoURL = URL(string: urlString)
    }
    override init() {
        super.init()
    }
}
