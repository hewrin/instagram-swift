//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController ()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
  
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    @IBAction func onCameraPressed(sender: AnyObject) {
//        imagePicker = UIImagePickerController ()
//        imagePicker.delegate = self
//        imagePicker.sourceType = .Camera
//        
//        presentViewController(imagePicker, animated: true, completion: nil)
//
//    }
    
    func selectPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
  
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            print("1")
            self.image = possibleImage
//            self.performSegueWithIdentifier("cameraToSubmitSegue", sender: self)
            UIImageWriteToSavedPhotosAlbum(possibleImage, nil, nil, nil)
            
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print("2")
            self.image = possibleImage
//            self.performSegueWithIdentifier("cameraToSubmitSegue", sender: self)
            UIImageWriteToSavedPhotosAlbum(possibleImage, nil, nil, nil)
            // need to change the NIL (selector)
        } else {
            print("3")
            return
        }
        dismissViewControllerAnimated(true) { 
            self.performSegueWithIdentifier("cameraToSubmitSegue", sender: self)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! SubmitViewController
        destination.image = self.image
    }
  }
