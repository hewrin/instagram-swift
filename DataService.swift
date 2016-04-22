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
    
    var BASE_REF: Firebase{
        return _BASE_URL
    }
    
}