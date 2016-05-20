//
//  FollowersList.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/19/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class FollowersList: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followersTableView: UITableView!
  
    
    var users: [InstaUser] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        self.navigationController?.navigationBarHidden = false
        
        
        self.showLoader("Loading...")
        InstagramAPIManager.apiManager.getUserFollowers(NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!) { (users, success) in
            if success {
                self.users = users
                print("User \(users.count)")
                self.reloadTable()
                self.hideLoader()
            }
            else {
                self.users = [InstaUser]()
                self.reloadTable()
            }
        }
        
    }
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowCell", forIndexPath: indexPath) as! FollowCell
        
            let profilePictureUrl = users[indexPath.row].profilePicture
            if CacheManager.sharedInstance.isCashed(profilePictureUrl) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     var photo = CacheManager.sharedInstance.objectForKey(profilePictureUrl) as! UIImage
                     Utils.makeImageRound(cell.userPhoto)
                     cell.userPhoto.image = photo })
            }
            else {
                Utils.loadImage(profilePictureUrl, completion: { (image, loaded) in
                    if loaded {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                             Utils.makeImageRound(cell.userPhoto)
                             cell.userPhoto.image = image })
                    }
                })
            
            }
         cell.nameLabel.text = self.users[indexPath.row].fullName
         return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.followersTableView.frame.size.height / 8)
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.followersTableView.reloadData()
            
        })
    }
    

}
