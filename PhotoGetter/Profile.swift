//
//  Profile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit


class Profile: BaseViewController {

   
    
    @IBOutlet weak var profileTopBar: UINavigationBar!
    @IBOutlet weak var usernameTopLabel: UILabel!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var settingsBarItem: UIBarButtonItem!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postCountButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
         //make image round
        self.makeImageRound(self.profilePicture)
        //make buttons square
        
        self.settingsBarItem.setFAIcon(FAType.FACog, iconSize: 20)
        
        InstagramAPIManager.apiManager.getUserInfoById(NSUserDefaults.standardUserDefaults().stringForKey("id")!, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.usernameTopLabel.text = user!.username.uppercaseString
                    self.bioLabel.text = user!.fullName
                    self.followersButton.setTitle(String(user!.numberOfFollowers), forState: UIControlState.Normal)
                    self.postCountButton.setTitle(String(user!.numberOfPosts), forState: UIControlState.Normal)
                    self.followingButton.setTitle(String(user!.numberFollowing), forState: UIControlState.Normal)
                })
                    
                if (CacheManager.sharedInstance.objectForKey(user!.profilePicture) != nil) {
                    self.profilePicture.image = CacheManager.sharedInstance.objectForKey(user!.profilePicture) as? UIImage
                }
                    
                else {
                    Utils.loadImage(user!.profilePicture, completion: { (image, loaded) in
                        if loaded {
                           self.profilePicture.image = image
                        }
                        else {
                         return
                        }
                    })
                
                }
            }
                    
            else {
                return
            }
        })
}
    
    
    func clearCookies() {
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if storage.cookies?.count > 0 {
            for cookie in storage.cookies! as [NSHTTPCookie] {
                storage.deleteCookie(cookie)
            }
            self.performSegueWithIdentifier("Logout", sender: self)
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    func makeImageRound(image: UIImageView) {
        //let width = self.view.frame.size.width / 7.0
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    
    }

    @IBAction func makeLogout(sender: AnyObject) {
        self.clearCookies()

    }
    
}
