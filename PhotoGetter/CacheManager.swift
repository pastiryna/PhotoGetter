//
//  CacheManager.swift
//  PhotoGetter
//
//  Created by IrynaP on 4/29/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import Foundation
import UIKit

class CacheManager: NSCache {
    
    static let sharedInstance = CacheManager()
    
    func cacheImage(imageUrl: String, image: UIImage) {
        //let imageURl = NSURL(string: imageUrl)
        if let cachedImage = CacheManager.sharedInstance.objectForKey(imageUrl) {
            return
        }
        else {
             CacheManager.sharedInstance.setValue(image, forKey: imageUrl)
        }
    }

    func isCashed(key: String) -> Bool {
        if let _ = CacheManager.sharedInstance.objectForKey(key) as? UIImage {
            return true
        }
        else {
            return false
        }
    }

}
