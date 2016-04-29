//
//  ProfileViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [Photo]()
    var sentImage : Photo?
    override func viewDidLoad() {
        super.viewDidLoad()
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let rootReference = DataService.dataService.BASE_REF
            let photoRef = DataService.dataService.PHOTO_REF
            let username = NSUserDefaults.standardUserDefaults().objectForKey("username") as! String
            self.title = username
            if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                let currentUser = rootReference.childByAppendingPath("users").childByAppendingPath(currentUserID)
                let userPhotos = currentUser.childByAppendingPath("photos")
                
                userPhotos.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    if !(snapshot.value is NSNull) {
                        if let value = snapshot.value as? [String: AnyObject] {
                            print("value is good")
                            for (key,_) in value {
                                let childPhotoRef = photoRef.childByAppendingPath("\(key)")
                                print("\(childPhotoRef)")
                                
                                childPhotoRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                                    if let imageUrl = snapshot.value["url"] as? String {
                                        print("goes here")
                                        
                                        let url = NSURL(string: imageUrl)
                                        let data = NSData(contentsOfURL: url!)
                                        let image = UIImage(data: data!)
                                        let newPhoto = Photo(key :key,photo: image!)
                                        self.images.append(newPhoto)
                                        self.collectionView.reloadData()
                                        
                                    }
                                    
                                })
                            }
                        }
 
                    }
                    }, withCancelBlock: { error in
                        print(error.description)
                })
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }

     
        
    }
    
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! InstagramPhotoCell
        let photo = self.images[indexPath.row]
        cell.imageView.image = photo.image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.sentImage = self.images[indexPath.row]
        self.performSegueWithIdentifier("viewPhotoSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PhotoViewController {
         destination.photo = self.sentImage
        }
    }
    @IBAction func logoutButton(sender: AnyObject) {
        
        
        DataService.dataService.BASE_REF.unauth()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("Login") as! LoginViewController
        self.presentViewController(nextViewController, animated:true, completion:nil)
        
    }
}
