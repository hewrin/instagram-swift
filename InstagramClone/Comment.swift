//
//  File.swift
//  InstagramClone
//
//  Created by Faris Roslan on 28/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation

class Comment {

    var body: String?
    var username: String?
    
    init(body: String, username: String) {
        self.body = body
        self.username = username
    }
}