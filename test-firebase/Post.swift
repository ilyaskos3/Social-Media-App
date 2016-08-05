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
    var username: String!
    var postKey: String!
    var postRef: FIRDatabaseReference!
    
    init( desc: String, uname: String){
        self.postDescription = desc
        self.username = uname
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
        self.username = ""
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