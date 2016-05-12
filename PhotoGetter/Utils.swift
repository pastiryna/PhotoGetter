//
//  Utils.swift
//  
//
//  Created by IrynaP on 5/4/16.
//
//

import Foundation
import UIKit

class Utils {
       
    
    static func loadImage(urlString: String, completion: (image: UIImage, loaded: Bool) -> Void) {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        let session = NSURLSession.sharedSession()
        _ = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                let image = UIImage(data: data!)
                CacheManager.sharedInstance.setObject(image!, forKey: urlString)
                completion(image: image!, loaded: true)
            }
            else {
                completion(image: UIImage(), loaded: false)
            }
        }).resume()
    }
    

    
}