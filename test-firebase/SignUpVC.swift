//
//  SignUpVC.swift
//  test-firebase
//
//  Created by ilyas kose on 05/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var newImg : UIImageView!
    @IBOutlet weak var textMail : UITextField!
    @IBOutlet weak var textPass : UITextField!
    @IBOutlet weak var addImgBtn : UIButton!
    @IBOutlet weak var textNameSurname: UITextField!
    
    var imagePicker : UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //newImg.layer.cornerRadius = 10
        //newImg.clipsToBounds = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        newImg.image = image
    }
    
    @IBAction func addImgBtnPressed(sender: UIButton!){
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnPressed(sender: UIButton!){
        if let email = textMail.text where email != "", let pass = textPass.text where pass != "",let name = textNameSurname.text where name != "" {
            
            FIRAuth.auth()?.createUserWithEmail(email, password: pass, completion: { (user, error) in
                if error != nil{
                    self.showAlert("Problem", msg: "Can not create account")
                } else {
                    let userData = ["provider":"email","name":name]
                    DataService.dService.createFirebaseUser(user!.uid, user: userData)
                    self.uploadProfilePic()
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
            self.navigationController?.popViewControllerAnimated(true)
        } else {
            showAlert("Fields empty", msg: "email and password required")
        }
    }
    
    func uploadProfilePic(){
        let data = UIImageJPEGRepresentation(self.newImg.image!, 0.1)
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        let postId = "\(FIRAuth.auth()!.currentUser!.uid)"
        let imagePath = "profilePics/\(postId)/profile.jpg"
        let storageRef = FIRStorage.storage().reference()
        let uploadTask = storageRef.child(imagePath).putData(data!, metadata: metadata)
        uploadTask.observeStatus(.Progress) { snapshot in
            // Upload reported progress
            if let progress = snapshot.progress {
                let percentComplete = 100.0 * Double(progress.completedUnitCount) / Double(progress.totalUnitCount)
                print(percentComplete)
            }
        }
    }
}
