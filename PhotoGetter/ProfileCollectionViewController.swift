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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoCollectionView.delegate = self
        self.photoCollectionView.dataSource = self       
        
        
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView (collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("InstagramCell", forIndexPath: indexPath) as! InstagramCollectionViewCell
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenWidth = self.view.frame.size.width
        let cellWidth = (screenWidth - 2) / 3.0   //Replace the divisor with the column count requirement. Make sure to have it in float.
        let size: CGSize = CGSizeMake(cellWidth, cellWidth);
        return size;
    }
    


}
