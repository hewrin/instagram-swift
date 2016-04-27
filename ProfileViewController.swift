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
    var images = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let rootReference = DataService.dataService.BASE_REF
        let photoRef = DataService.dataService.PHOTO_REF
        if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String {
           let currentUser = rootReference.childByAppendingPath("users").childByAppendingPath(currentUserID)
           let userPhotos = currentUser.childByAppendingPath("photos")
            
            userPhotos.observeEventType(.Value, withBlock: { snapshot in
                if !(snapshot.value is NSNull) {
                    if let value = snapshot.value as? [String: AnyObject] {
                     for (key,value) in value {
                        let childPhotoRef = photoRef.childByAppendingPath("\(key)")
                         print("\(childPhotoRef)")
                        
                        childPhotoRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                            if let imageUrl = snapshot.value["url"] as? String {
                                
                                let url = NSURL(string: imageUrl)
                                let data = NSData(contentsOfURL: url!)
                                print("\(url)")
                                print("here")
                                //make sure your image in this url does exist, otherwise unwrap in a if let check
                                let image = UIImage(data: data!)
                                self.images.append(image!)
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
     
        
    }
    
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("pictureCell", forIndexPath: indexPath) as! InstagramPhotoCell
        let image = self.images[indexPath.row]
        cell.imageView.image = image
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
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
