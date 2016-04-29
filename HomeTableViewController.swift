//
//  HomeTableViewController.swift
//  InstagramClone
//
//  Created by Joanne Lim on 22/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    var images = [FollowerFeedPhoto]()
    var selectedImage : Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            let currentUserId = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
            let username = NSUserDefaults.standardUserDefaults().valueForKey("username") as! String
            let userRef = DataService.dataService.USER_REF.childByAppendingPath(currentUserId)
            let photoRef = DataService.dataService.PHOTO_REF
            let userPhotosRef = userRef.childByAppendingPath("photos")
            let feedRef = userRef.childByAppendingPath("followerfeed")
            feedRef.observeEventType(.Value, withBlock: { snapshot in
                if let feedValue = snapshot.value as? [String: AnyObject] {
                    for(key,value) in feedValue {
                        let photoKey = key
                        let username = value["username"] as! String
                        let url = value["url"] as! String
                        let user_id = value["user_id"] as! String
                        let caption = value["caption"] as! String
                        let followerFeed = FollowerFeedPhoto(photoKey: photoKey,caption:caption, username:username, url:url,user_id:user_id)
                        self.images.append(followerFeed)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.tableView.reloadData()
                        })
                    }
                }
            })
            userPhotosRef.observeEventType(.Value, withBlock: { snapshot in
                if !(snapshot.value is NSNull) {
                    if let value = snapshot.value as? [String: AnyObject] {
                        for (key,_) in value {
                            let childPhotoRef = photoRef.childByAppendingPath("\(key)")
                            childPhotoRef.observeEventType(.Value, withBlock: { (snapshot) -> Void in
                                print(snapshot.value)
                                if let imageUrl = snapshot.value["url"] as? String {
                                    let photoKey = snapshot.key
                                    let username = username
                                    let url = imageUrl
                                    let user_id = currentUserId
                                    let caption = snapshot.value["caption"] as! String
                                    let followerFeed = FollowerFeedPhoto(photoKey: photoKey,caption:caption, username:username, url:url,user_id:user_id)
                                    self.images.append(followerFeed)
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        self.tableView.reloadData()
                                    })
                                }
                            })
                        }
                    }
                }
            })
            dispatch_async(dispatch_get_main_queue()) {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! InstagramTableViewCell
        let followerFeed = self.images[indexPath.row]
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let url = NSURL(string: followerFeed.url!)
            let data = NSData(contentsOfURL: url!)
            let image = UIImage(data: data!)
            dispatch_async(dispatch_get_main_queue()) {
                cell.imageCellView!.image = image
            }
        }
        cell.captionLabel.text = followerFeed.caption
        cell.usernameLabel.text = followerFeed.username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feedphoto = self.images[indexPath.row]
        let url = NSURL(string: feedphoto.url!)
        let data = NSData(contentsOfURL: url!)
        let image = UIImage(data: data!)
        let photo = Photo(key: feedphoto._photoKey, photo: image!)
        self.selectedImage = photo
        self.performSegueWithIdentifier("HomeToPhotoSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? PhotoViewController {
            
            destination.photo = self.selectedImage
        }
    }
    
    
}
