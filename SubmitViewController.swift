//
//  SubmitViewController.swift
//  InstagramClone
//
//  Created by Faris Roslan on 25/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit
import AWSS3
class SubmitViewController: UIViewController {
    var image: UIImage?
    @IBAction func onUploadButtonPressed(sender: AnyObject) {
        let ext = "png"
        // Create a URL in the /tmp directory
        let imageURL = NSURL(fileURLWithPath: NSTemporaryDirectory().stringByAppendingString("TempImage.png"))
        
        // save image to URL
        UIImagePNGRepresentation(self.image!)?.writeToURL(imageURL, atomically: true)
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.body = imageURL
        uploadRequest.key = NSProcessInfo.processInfo().globallyUniqueString + "." + ext
        uploadRequest.bucket = S3BucketName
        uploadRequest.contentType = "image/" + ext
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        transferManager.upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if let error = task.error {
                
                print("Upload failed ❌ (\(error))")
            }
            if let exception = task.exception {
                
                print("Upload failed ❌ (\(exception))")
            }
            if task.result != nil {
                let urlString = "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)"
                let s3URL = NSURL(string: urlString)!
                print("Uploaded to:\n\(s3URL)")
                let rootReference = DataService.dataService.BASE_REF
                
                if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                    
                    let currentUser = rootReference.childByAppendingPath("users").childByAppendingPath(currentUserID)
                    let captionText = self.captionTextField!.text! as String
                    let  photo = ["url": urlString, "caption": captionText, "user_id": currentUserID]

                    
                    let photoRef = rootReference.childByAppendingPath("photos").childByAutoId()
                    
                    photoRef.setValue(photo, withCompletionBlock: { (error, result) -> Void in
                        
                        if error == nil {
                            let photoId = photoRef.key
                            let newPhoto = [photoId : true ]
                            currentUser.childByAppendingPath("photos").updateChildValues(newPhoto)
                            
                                let followerRef = currentUser.childByAppendingPath("followers")
                                print("First")
                            followerRef.observeEventType(.Value, withBlock: { snapshot in
                                  print(snapshot.value)
                                  if let value = snapshot.value as? [String: AnyObject] {
                                    for(key,_) in value {
                                      let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
                                      let userFollowerRef = rootReference.childByAppendingPath("users").childByAppendingPath(key).childByAppendingPath("followerfeed").childByAutoId()
                                        let feedDict = [photoId: true,"url":urlString,"caption": captionText,"user_id":currentUserID, "username":username]
                                      userFollowerRef.updateChildValues(feedDict as [NSObject : AnyObject])
                                    }
                                  }
                                })
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
                            viewController.selectedIndex = 2;
                            self.presentViewController(viewController, animated: true, completion: nil)
                        } else {
                            print("(\(error))")
                        }
                    })
                }
            }
            else {
                print("Unexpected empty result.")
            }
            return nil
        }
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = image
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}