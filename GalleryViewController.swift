//
//  GalleryViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit
import MobileCoreServices

class GalleryViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
       presentViewController(imagePicker, animated: true, completion: nil)
    }

 
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count/10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }

}
  