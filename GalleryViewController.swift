//
//  GalleryViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit
import MobileCoreServices
import Photos
class GalleryViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    var assetResults = PHFetchResult()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.assetResults = PHAsset.fetchAssetsWithMediaType(.Image,
            options: nil)
        self.collectionView.reloadData()
//        imagePicker.delegate = self
//        imagePicker.allowsEditing = false
//        imagePicker.sourceType = .PhotoLibrary
//        
//       presentViewController(imagePicker, animated: true, completion: nil)
    }

 
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .ScaleAspectFit
//            imageView.image = pickedImage
//        }
//        
//        dismissViewControllerAnimated(true, completion: nil)
//    }
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.assetResults.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! InstagramPhotoCell
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        let asset = self.assetResults[indexPath.row]
        option.synchronous = true
        manager.requestImageForAsset(asset as! PHAsset, targetSize: CGSize(width: cell.imageView.frame.width, height: cell.imageView.frame.width), contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
            cell.imageView.image = thumbnail
            self.images.append(thumbnail)
        })
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.imageView.image = self.images[indexPath.row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as! SubmitViewController
        destination.image = self.imageView.image
        
    }
}
  