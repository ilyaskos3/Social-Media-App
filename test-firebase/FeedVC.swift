//
//  FeedVC.swift
//  test-firebase
//
//  Created by ilyas kose on 04/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//

import UIKit
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView : UITableView!
    var posts = [Post]()
    
    @IBOutlet weak var postField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        DataService.dService.REF_POSTS.observeEventType(.Value, withBlock:  { data in
            
            self.posts = []
            if let datas = data.children.allObjects as? [FIRDataSnapshot]{
                for dta in datas{
                    print(dta)
                    
                    if let postDict = dta.value as? Dictionary<String,AnyObject>{
                        let key = dta.key
                        let post = Post(postKey: key, dictionary: postDict)
                        self.posts.append(post)
                    }
                }
            }
            
            
            self.tableView.reloadData()
        })
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        
        if let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as? PostCell{
            cell.configureCell(post)
            return cell
        }else {
            return PostCell()
        }
    }
    
    @IBAction func postBtnPressed(sender: AnyObject) {
        if let text = postField.text {
            var post: Dictionary<String, AnyObject> = ["description": text, "likes": 0]
            
            let postID = DataService.dService.REF_POSTS.childByAutoId()
            
            postID.setValue(post)
            
            postField.text = ""
            tableView.reloadData()
        }
    }
    
    

}
