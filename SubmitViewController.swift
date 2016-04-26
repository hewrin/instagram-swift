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
                
                let s3URL = NSURL(string: "http://s3.amazonaws.com/\(S3BucketName)/\(uploadRequest.key!)")!
                print("Uploaded to:\n\(s3URL)")
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
