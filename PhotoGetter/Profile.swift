//
//  Profile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import FontAwesomeKit
//import FontAwesome_swift

class Profile: BaseViewController {

    @IBOutlet weak var logoutBarItem: UIBarButtonItem!
    @IBOutlet weak var profileBarItem: UITabBarItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //let icon = FAKIonIcons.personIconWithSize(20)
       //var i = 0
        
        
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
    
    

    
}
