//
//  Profile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
//import FontAwesomeKit
//import FontAwesome_swift

class Profile: BaseViewController {

   
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var profileTopBar: UINavigationBar!
    @IBOutlet weak var usernameTopLabel: UILabel!
    @IBOutlet weak var profileContainer: UIView!
    
    
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
    
        
    }
    
    @IBAction func makeLogout(sender: AnyObject) {
        self.clearCookies()
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
        let width = self.view.frame.size.width / 7.0
        
        image.layer.cornerRadius = image.frame.size.width / 2
        
        image.clipsToBounds = true

    
    }

    
}
