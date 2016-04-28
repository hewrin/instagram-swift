//
//  FollowerFeedPhoto.swift
//  InstagramClone
//
//  Created by Faris Roslan on 28/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation

class FollowerFeedPhoto {
    var _photoKey: String!
    var caption : String?
    var url : String?
    var user_id : String?
    var username : String?
    
    init(photoKey: String,caption: String, username: String, url: String, user_id: String) {
        self._photoKey = photoKey
        self.caption = caption
        self.username = username
        self.user_id = user_id
        self.url = url
    }
}
