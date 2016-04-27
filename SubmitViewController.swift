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
                       
                       let followingRef = currentUser.childByAppendingPath("following")
                       
                        followingRef.observeEventType(.Value, withBlock: { snapshot in
                            print(snapshot.value)
                            if !(snapshot.value is NSNull) {
                                for child in snapshot.children {
                                    
                                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                                    let someValue = childSnapshot.value["key"] as! String
                                    print("\(someValue)")
                                }
                            }
                            }, withCancelBlock: { error in
                                print(error.description)
                        })
                        
                    self.performSegueWithIdentifier("afterUploadPhoto", sender: self)
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


}
