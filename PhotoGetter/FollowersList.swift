//
//  FollowersList.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/19/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class FollowersList: BaseViewController, UITableViewDataSource, UITableViewDelegate, UINavigationBarDelegate {
    
    @IBOutlet weak var followersTableView: UITableView!
  
    
    var users: [InstaUser] = []
    var refreshControl = UIRefreshControl()
    var url: String = ""
    var screenTitle: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.hidesBottomBarWhenPushed = false
        
        self.navigationController?.navigationBar.barTintColor = Constants.BRAND_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.refreshControl.addTarget(self, action: #selector(FollowersList.refreshHandler), forControlEvents: UIControlEvents.ValueChanged)
        self.followersTableView.addSubview(self.refreshControl)
       
        //self.title = self.screenTitle
        
        self.showLoader("Loading...")
        print("Url \(self.url)")
        InstagramAPIManager.apiManager.getUserFollowersFollowing(self.url, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!) { (users, success) in
            if success {
                self.users = users
                print("User \(users.count)")
                self.reloadTable()
                self.hideLoader()
            }
            else {
                self.users = [InstaUser]()
                self.hideLoader()
                self.reloadTable()
            }
        }
        
    }
  
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false 
        self.tabBarController?.hidesBottomBarWhenPushed = false
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
                     let photo = CacheManager.sharedInstance.objectForKey(profilePictureUrl) as! UIImage
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
    
    
    func refreshHandler() {
        self.reloadTable()
        self.refreshControl.endRefreshing()
        
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let index = indexPath.row
         let profile = self.storyboard?.instantiateViewControllerWithIdentifier("Profile") as! Profile
         profile.user.id = self.users[index].id
        
         print("Id \(profile.user.id)")
         self.navigationController?.pushViewController(profile, animated: true)
    }
  

}
