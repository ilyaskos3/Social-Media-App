//
//  PostCell.swift
//  test-firebase
//
//  Created by ilyas kose on 04/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var imgProfile : UIImageView!
    @IBOutlet weak var imgLike : UIImageView!
    @IBOutlet weak var textPost : UITextView!
    @IBOutlet weak var labelLile : UILabel!
    @IBOutlet weak var labelUserName: UILabel!
    
    var post: Post!

    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: "likeBtnPressed")
        tap.numberOfTapsRequired = 1
        imgLike.addGestureRecognizer(tap)
        imgLike.userInteractionEnabled = true
    }
    
    override func drawRect(rect: CGRect) {
        imgProfile.layer.cornerRadius = imgProfile.frame.size.width / 2
        imgProfile.clipsToBounds = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(post: Post, user : User){
        self.post = post
        self.textPost.text = post.postDescription
        self.labelLile.text = String("\(post.likes) Likes")
        self.labelUserName.text = post.userName
        
        let likeRef = DataService.dService.REF_CURRENT_USER.child("likes").child(post.postKey)
        likeRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            
            if let notExist = snapshot.value as? NSNull{
                self.imgLike.image = UIImage(named: "e-hearth")
            } else {
                self.imgLike.image = UIImage(named: "f-hearth")
            }
        })
    }
    
    func likeBtnPressed(){
        let likeRef = DataService.dService.REF_CURRENT_USER.child("likes").child(post.postKey)
        likeRef.observeSingleEventOfType(.Value, withBlock:  { snapshot in
            
            if let notExist = snapshot.value as? NSNull{
                self.imgLike.image = UIImage(named: "f-hearth")
                self.post.adjustLikes(true)
                likeRef.setValue(true)
            } else {
                self.imgLike.image = UIImage(named: "e-hearth")
                self.post.adjustLikes(false)
                likeRef.removeValue()
            }
        })

    }

}
