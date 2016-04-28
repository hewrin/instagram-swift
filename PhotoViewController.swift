//
//  PhotoViewController.swift
//  InstagramClone
//
//  Created by Faris Roslan on 27/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var photo : Photo?
    var comments = [Comment]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.photo!.image
        let rootReference = DataService.dataService.BASE_REF
        let photoKey = self.photo!.photoKey
        let likeRef = rootReference.childByAppendingPath("photos/\(photoKey)/likes")
        let commentRef = rootReference.childByAppendingPath("comments")
        likeRef.observeEventType(.Value, withBlock: { snapshot in
          if !(snapshot.value is NSNull) {
            self.likeCountLabel.text = String(snapshot.value.count)
          }
        })
        commentRef.queryOrderedByChild("photo_id").queryEqualToValue(photoKey).observeEventType(.Value, withBlock: { snapshot in
            if let value = snapshot.value as? [String: AnyObject] {
                for (key,value) in value {
                    if let body = value["body"] as? String {
                        
                        let commenterRef = rootReference.childByAppendingPath("users").childByAppendingPath("\(value["user_id"])")
                        
                        commenterRef.observeEventType(.Value, withBlock: { snapshot in
                            if let username = snapshot.value["username"] as? String {
                                let comment = Comment(body: body, username:  username)
                                self.comments.append(comment)
                                self.tableView.reloadData()
                            }
                        })
                        
                    }
                }
            }
        })
    }

    @IBAction func onLikeButtonPressed(sender: AnyObject) {
        let rootReference = DataService.dataService.BASE_REF
        let photoKey = self.photo!.photoKey
        let likeRef = rootReference.childByAppendingPath("photos/\(photoKey)/likes").childByAutoId()
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let userLike = [currentUserID : true] 
        likeRef.setValue(userLike)
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath)
        let comment = self.comments[indexPath.row]
        cell.textLabel!.text = comment.body
        cell.detailTextLabel?.text = comment.username
        return cell
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let rootReference = DataService.dataService.BASE_REF
        let photoKey = self.photo!.photoKey 
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
        let commentRef = rootReference.childByAppendingPath("comments").childByAutoId()
         if let comment = self.commentTextField.text! as? String {
          let commentDict = ["body": comment,"photo_id": "\(photoKey)","user_id": "\(currentUserID)"]
        
          commentRef.setValue(commentDict, withCompletionBlock: {(error, result) -> Void in
            if error == nil {
                let commenterRef = rootReference.childByAppendingPath("users").childByAppendingPath(currentUserID)
                
                commenterRef.observeEventType(.Value, withBlock: { snapshot in
                    if let username = snapshot.value["username"] as? String {
                        let comment = Comment(body: comment, username:  username)
                        self.comments.append(comment)
                        self.tableView.reloadData()
                    }
                })
                self.tableView.reloadData()
            } else {
                print("(\(error))")
            }
        })
        return true
        }
    }
}
