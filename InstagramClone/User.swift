//
//  username.swift
//  InstagramClone
//
//  Created by Joanne Lim on 27/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation

class User {
    
    private var _userKey: String!
    var email: String!
    var photos: [String: String]!
    var username: String!
    
    var userKey: String {
        return _userKey
    }
    
    init(key: String, dict: [String: AnyObject]){
        self._userKey = key
        
        if let email =  dict["email"] as? String{
            self.email = email
        }

       if let photos =  dict["photos"] as? [String: String]{
            self.photos = photos
        }
        
        if let username =  dict["username"] as? String{
            self.username = username
        }
        
  }
    func checkIfFollowingThisUser(completionHandler: (checkResult: Bool)->Void) -> Void {
        let rootReference = DataService.dataService.BASE_REF
        let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String
        let currentUser = rootReference.childByAppendingPath("users").childByAppendingPath(currentUserID)
        let targetRef = currentUser.childByAppendingPath("followings").childByAppendingPath(self.userKey)
        
        targetRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let result = snapshot.value.isEqual(NSNull())
            completionHandler(checkResult: !result)
        })
    }
}