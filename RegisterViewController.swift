//
//  RegisterViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()


        
    }

    @IBAction func submitButtonPressed(sender: AnyObject) {
        if let username = usernameTextField.text, email = emailTextField.text, password = passwordTextField.text{
            let rootReference = DataService.dataService.BASE_REF
            rootReference.createUser(email, password: password, withValueCompletionBlock: { (error, result) in
                if error == nil{
                    let uid = result ["uid"] as? String
                    
                    let userDict = ["email":email, "username":username]
                    
                    let currentUser = rootReference.childByAppendingPath("users").childByAppendingPath(uid)
                    
                    currentUser.setValue(userDict)
                    
                    NSUserDefaults.standardUserDefaults().setValue(uid, forKey: "uid")
                    self.performSegueWithIdentifier("Loggedin", sender: nil)
                    // can consider for the login page to jump back to the login page
                    
                }else{
                    
                    let alertController = UIAlertController(title: "Error Message", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            })
            
        }
    }

}
