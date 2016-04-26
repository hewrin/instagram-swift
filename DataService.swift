//
//  DataService.swift
//  InstagramClone
//
//  Created by Faris Roslan on 22/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let dataService = DataService()
    private let _BASE_URL = Firebase(url: BASE_URL)
    private let _USER_REF = Firebase(url: "\(BASE_URL)/users")
    
    var BASE_REF: Firebase{
        return _BASE_URL
    }
    
    var USER_REF: Firebase{
        return _USER_REF
    }
    
    var CURRENT_USER_REF: Firebase{
        var currentRef: Firebase?
        if let currentUserID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as? String{
            currentRef = USER_REF.childByAppendingPath(currentUserID)
        }
        return currentRef!
    }
    
}