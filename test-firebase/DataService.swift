//
//  DataService.swift
//  test-firebase
//
//  Created by ilyas kose on 04/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

class DataService{
    static let dService = DataService()
    
    var REF_BASE = URL_BASE
    var REF_POSTS = URL_BASE.child("posts")
    var REF_USERS = URL_BASE.child("users")
    
    
    func createFirebaseUser(uid: String, user: Dictionary<String, String>){
        REF_USERS.child(uid).updateChildValues(user)
    }
    
    var REF_CURRENT_USER : FIRDatabaseReference{
        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        let user = URL_BASE.child("users").child(uid)
        return user
    }
}

func getUserName(id : String) -> String{
    var name = ""
    DataService.dService.REF_USERS.child(id).observeSingleEventOfType(.Value, withBlock: { snapshot in
        name = snapshot.value!["name"] as! String
    }){ (error) in
        print(error.localizedDescription)
    }
    return name
}