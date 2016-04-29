//
//  OtherUserProfileViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 26/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class OtherUserProfileViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImageView: UIImageView!
    var userImages = [Photo]()
    var isFollowing = false
    var user : User!
    var sentImage : Photo?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = user.username
        self.user.checkIfFollowingThisUser({checkResult in
            if checkResult{
                self.followButton.setTitle("Followed", forState: UIControlState.Normal) 
                self.followButton.enabled = false
                self.isFollowing = true
            }
        })
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            
            DataService.dataService.USER_REF.childByAppendingPath(self.user!.userKey).childByAppendingPath("photos").observeSingleEventOfType(.ChildAdded, withBlock: { (snapshot) -> Void in
                
                DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeSingleEventOfType(.Value, withBlock: { (snapshot) -> Void in
                    print(snapshot.value)
                    print(snapshot.key)
                    if let imageUrl = snapshot.value["url"] as? String {
                        
                        let url = NSURL(string: imageUrl)
                        let data = NSData(contentsOfURL: url!)
                        let image = UIImage(data: data!)
                        let newPhoto = Photo(key :snapshot.key,photo: image!)
                        self.userImages.append(newPhoto)
                        self.collectionView.reloadData()
                        
                    }
                })
            })
            dispatch_async(dispatch_get_main_queue()) {
                self.collectionView.reloadData()
            }
        }

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)as! InstagramPhotoCell
        let userProfile = self.userImages[indexPath.row]
        cell.imageView.image = userProfile.image
        return cell
    }
 
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.sentImage = self.userImages[indexPath.row]
        self.performSegueWithIdentifier("viewPhotoSegue", sender: self)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PhotoViewController {
            destination.photo = self.sentImage
        }
    }
    @IBAction func onFollowingButtonPressed(sender: AnyObject) {
        
        
        if (!isFollowing) {
            self.followButton.enabled = false
            self.followButton.titleLabel?.text = "Followed"
            
            // current user plus FOLLOWING - creating a new branch in the user database called following
            
            DataService.dataService.CURRENT_USER_REF.childByAppendingPath("followings").updateChildValues([user!.userKey : true], withCompletionBlock: { (error, ref) -> Void in
                
                // creating the current userID based on the USERDEFAULT called UID
                if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                    DataService.dataService.USER_REF.childByAppendingPath(self.user?.userKey).childByAppendingPath("followers").updateChildValues([currentUserID:true])
                                }
            })
        
        }
    }
    
    
}//the final closing