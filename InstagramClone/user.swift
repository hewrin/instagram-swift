//
//  username.swift
//  InstagramClone
//
//  Created by Joanne Lim on 27/4/16.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation

class user {
    
    private var _userKey: String!
//    var email: String!
//    var photos: [String: String]
    var username: String!
    
    var userKey: String {
        return _userKey
    }
    
    init(key: String, dict: [String: AnyObject]){
        self._userKey = key
        
//        let email =  dict["email"] as? String
//            self.email = email
        
        
//        let photos =  dict["photos"] as? [String: String]
//            self.photos = photos!
        
        
        if let username =  dict["username"] as? String{
            self.username = username
        }
        
  }
}