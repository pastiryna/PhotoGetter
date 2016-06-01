//
//  Utils.swift
//  
//
//  Created by IrynaP on 5/4/16.
//
//

import Foundation
import UIKit
import Photos



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
    
    
    static func makeImageRound(image: UIImageView) {
        //let width = self.view.frame.size.width / 7.0
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }

    static func imageFromFile(imageURL: String) -> UIImage? {
        var image = UIImage()
        let asset = PHAsset.fetchAssetsWithALAssetURLs([NSURL(string: imageURL)!], options: nil).firstObject as! PHAsset
        let targetSize = CGSizeMake(300, 300)
        var options = PHImageRequestOptions()        
        PHImageManager.defaultManager().requestImageForAsset(asset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFit, options: options, resultHandler: {
            (result, info) in
            // imageE - UIImageView on scene
            //self.imageE.image = result
            image = result!
        })
        return image
        
    }
        
}