//
//  ViewWithTable.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import MBProgressHUD



class ViewWithTable: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var photoTable: PhotoGetterTableView!
    @IBOutlet weak var feedBarItem: UITabBarItem!
    
    
    let user_id = "3152442007"
    var photoUrls: [String] = []
    let acc_tok = "3152442007.6080917.b6d6d78fd7d943b8bd86ca07258a5336"
    var loaded = false
    let date: Double = 1462529472
    
    
    let mario = "http://www.imagenspng.com.br/wp-content/uploads/2015/02/small-super-mario.png"
    
    var userPhotos: [UserPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.delegate = self
        photoTable.dataSource = self
        
        self.reloadTable()
        
        self.showLoader("Loading...")
        
        InstagramAPIManager.apiManager.getUserPhotos(InstagramAPIManager.apiManager.accessToken) { (photos, success) -> Void in
            self.hideLoader()
            if (success) {
                self.userPhotos = photos
                for i in photos {
                    self.photoUrls.append(i.getUrl()) }
                self.reloadTable()
            }
                
            else {
                self.photoUrls = [String]()
                self.reloadTable()
                
            }
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
   
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.width * 1.2)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoUrls.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath: indexPath) as! NewCell
        
        let photoUrl = self.photoUrls[indexPath.row]
        if (CacheManager.sharedInstance.objectForKey(photoUrl) != nil) {
            cell.photo.image = CacheManager.sharedInstance.objectForKey(photoUrl) as? UIImage
            
            cell.photoTitleLabel.text = self.userPhotos[indexPath.row].timePassed()
            print("Date \(self.userPhotos[indexPath.row].timePassed())")
            print("Cashed Image for row \(indexPath.row)")
            return cell
        }
        else {
            Utils.loadImage(photoUrl, completion: { (image, loaded) -> Void in
                if loaded {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                       // self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)
                         let imageWidth = self.view.frame.width
                         cell.photo.image = image
                       
                        cell.photoTitleLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
                        cell.photoTitleLabel.text = self.userPhotos[indexPath.row].timePassed()
                        print("Date \(self.userPhotos[indexPath.row].timePassed())")
                    })
                    
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let current = UIImage(named: "defaultImage")!
                        cell.photo.image = current
                        cell.photoTitleLabel.text = "defaultImage"
                    })
                }
            })
            return cell
        }
        
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.photoTable.reloadData()
            
        })
    
    }
    
    
    

}
