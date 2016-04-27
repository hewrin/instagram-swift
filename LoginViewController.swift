//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit
import AWSS3
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        if currentUserID != nil {
            //checks in user database
            if DataService.dataService.USER_REF.childByAppendingPath(currentUserID)!.authData != nil {
                self.performSegueWithIdentifier("LoggedIn", sender: nil)
            }
        }
        
        
    }


    @IBAction func goButtonPressed(sender: AnyObject) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            
            DataService.dataService.BASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) in
                if error != nil{
                    let alertController = UIAlertController(title: "Error Message", message: "\(error.localizedDescription)", preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }else{
                    
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")

                    self.performSegueWithIdentifier("LoggedIn", sender: nil)
                }
            })
        }
        
        
    }
 

}
