//
//  Photo.swift
//  InstagramClone
//
//  Created by Faris Roslan on 27/04/2016.
//  Copyright © 2016 Faris Roslan. All rights reserved.
//

import Foundation
import UIKit

class Photo {
    private var _photoKey: String!
    var image: UIImage?
    var photoKey: String {
        return _photoKey
    }
 
    init(key: String, photo: UIImage){
        self._photoKey = key
        self.image = photo
    }
}