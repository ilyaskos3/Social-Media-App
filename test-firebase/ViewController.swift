//
//  ViewController.swift
//  test-firebase
//
//  Created by ilyas kose on 03/08/16.
//  Copyright © 2016 ilyaskose. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKLoginKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var LabelEmail : UITextField!
    @IBOutlet weak var LabelPass : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        }

    @IBAction func fbButtonPressed(sender: AnyObject) {
        let fbLogin = FBSDKLoginManager()
        
        fbLogin.logInWithReadPermissions(["email"]){ ( facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) in
            if facebookError != nil {
                print("Facebook Login Failed. Error : \(facebookError)")
            } else {
                let accesToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Facebook Login Succesfull. token : \(accesToken)")
                
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                FIRAuth.auth()?.signInWithCredential(credential, completion: { (user,error) in
                    
                    if error != nil {
                        print("login failed!. error : \(error)")
                    } else {
                        print("Logged in. \(user)")
                        
                        let userData = ["provider": credential.provider]
                        DataService.dService.createFirebaseUser(user!.uid, user: userData)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
            }
        }
    }
    
    func showAlert(title: String, msg: String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func mailBtnPressed(sender: UIButton!){
        if let email = LabelEmail.text where email != "", let pass = LabelPass.text where pass != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user,error) in
                if error != nil {
                    print(error)
                } else {
                     self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showAlert("Fields empty", msg: "email and password required")
        }
    }
    
    @IBAction func signUpBtnPressed(sender: UIButton!){
       self.performSegueWithIdentifier(SEGUE_SIGN_UP, sender: nil)
    }
    
    @IBAction func signInBtnPressed(sender: UIButton!){
        if let email = LabelEmail.text where email != "", let pass = LabelPass.text where pass != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: pass, completion: { (user, error) in
                //print("xxxx" + error.debugDescription + "xxxx")
                if error != nil {
                    self.showAlert("Error", msg: "Please check your mail and password")
                } else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        } else {
            showAlert("Fields empty", msg: "email and password required")
        }
    }
}