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
    var user : User?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        DataService.dataService.USER_REF.childByAppendingPath(user!.userKey).observeEventType(.Value, withBlock: { (snapshot) in
            if let username = snapshot.value["username"] as? String{
                self.title = username
            }
        })
        
        
        DataService.dataService.USER_REF.childByAppendingPath(user!.userKey).childByAppendingPath("photos").observeEventType(.ChildAdded, withBlock: { (snapshot) -> Void in
            
            DataService.dataService.PHOTO_REF.childByAppendingPath(snapshot.key).observeEventType(.Value, withBlock: { (snapshot) -> Void in
                
                if let imageUrl = snapshot.value["url"] as? String {
                    
                    let url = NSURL(string: imageUrl)
                    let data = NSData(contentsOfURL: url!)
                    print("\(url)")
                    print("here")
                    //make sure your image in this url does exist, otherwise unwrap in a if let check
                    let image = UIImage(data: data!)
                    self.userImages.append(image!)
                    
                  
                    self.collectionView.reloadData()
                
                }
            })
        })
        
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userImages.count
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