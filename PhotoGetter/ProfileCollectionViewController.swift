//
//  ProfileCollectionViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/17/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class ProfileCollectionViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    var userPhotos: [UserPhoto] = []
    var userPhotoUrls: [String] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self
        self.showLoader("Loading...")
        
        InstagramAPIManager.apiManager.getUserPhotosById(NSUserDefaults.standardUserDefaults().stringForKey("id")!, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!) { (photos, success) in
            if success {
                self.hideLoader()
                self.userPhotos = photos
                self.reloadData()
            }
            else {
                self.reloadData()
            }
        }
        
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InstagramCell", forIndexPath: indexPath) as! InstagramCollectionViewCell
        
        let currentPhoto = self.userPhotos[indexPath.row]
        
        if (CacheManager.sharedInstance.objectForKey(currentPhoto.getUrl()) != nil) {
            cell.collectionCellImage.image = CacheManager.sharedInstance.objectForKey(currentPhoto.getUrl()) as! UIImage
            return cell
        }
        
        else {
            Utils.loadImage(currentPhoto.getUrl(), completion: { (image, loaded) in
                if loaded {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell.collectionCellImage.image = image
                    })
                }
//                else {
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        cell.collectionCellImage.image = UIImage(named: "defaultImage")!
//                    })
//
//                }
        })
        
        return cell
        
    }
}
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPhotos.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width
        let cellWidth = (screenWidth - 2) / 3.0   //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size: CGSize = CGSizeMake(cellWidth, cellWidth)
        return size
    }
    
    func reloadData() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.photoCollectionView.reloadData()
            
        })
    }
    


}
