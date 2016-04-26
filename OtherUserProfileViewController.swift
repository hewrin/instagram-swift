//
//  OtherUserProfileViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 26/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class OtherUserProfileViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userImageView: UIImageView!
    var userImages = [UIImage]()
    var isFollowing = false


    override func viewDidLoad() {
        super.viewDidLoad()
        // need the code to call the user's profile out (profile photo, captions and photos)

        
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userImages.count/10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath)as! InstagramPhotoCell
        let userProfile = self.userImages[indexPath.row]
        cell.imageView.image = userProfile
        return cell
    }
 
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }

    @IBAction func onFollowingButtonPressed(sender: AnyObject) {
        if (!isFollowing) {
            isFollowing = true
            sender.backgroundColor = UIColor.blueColor()
            // current user plus FOLLOWING - creating a new branch in the user database called following
            DataService.dataService.CURRENT_USER_REF.childByAppendingPath("Followings").updateChildValues([self.user.userKey: true], withCompletionBlock: { (error, ref) -> Void in
                // creating the current userID based on the USERDEFAULT called UID
                if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
                    DataService.dataService.USER_REF.childByAppendingPath(self.user.userKey).childByAppendingPath("Followers").updateChildValues([currentUserID:true])
                }
            })
        
        }
    
    }
    
    
}//the final closing