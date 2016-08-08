//
//  Post.swift
//  test-firebase
//
//  Created by ilyas kose on 04/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//


import Foundation
import Firebase

class Post{
    var postDescription: String!
    var likes: Int!
    var userUid: String!
    var userName: String!
    var postKey: String!
    var postRef: FIRDatabaseReference!
    
    init(desc: String, uname: String){
        self.postDescription = desc
        self.userName = uname
        self.postKey = ""
        self.likes = 0
    }
    
    init(postKey: String, dictionary: Dictionary<String, AnyObject>){
        self.postKey = postKey
        
        if let likes = dictionary["likes"] as? Int{
            self.likes = likes
        }
        
        if let desc = dictionary["description"] as? String{
            self.postDescription = desc
        }
        
        if let u_id = dictionary["user_uid"] as? String{
            self.userUid = u_id
        }
        
        if let name = dictionary["user_name"] as? String{
            self.userName = name
        }
        
        self.postRef = DataService.dService.REF_POSTS.child(postKey)
    }
    
    func adjustLikes(like: Bool){
        if like{
            likes = likes + 1
        } else {
            likes = likes - 1
        }
        
        postRef.child("likes").setValue(likes)
    }
}