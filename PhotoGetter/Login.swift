//
//  ViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 4/19/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import FontAwesomeKit
//import FontAwesome_swift


class ViewController: UIViewController {
    
    @IBOutlet weak var loginWithInstagram: UIButton!
    
    let CLIENT_ID = "6080917e427b4c6599b0056fc5ce54da"
    var authUrl = "https://api.instagram.com/oauth/authorize/?client_id=6080917e427b4c6599b0056fc5ce54da&redirect_uri=" + "https://api.instagram.com/v1/users/self/"  + "&response_type=token"

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func login(sender: AnyObject) {
        if self.isLoggedtoInstagram() {
            performSegueWithIdentifier("Show Table", sender: sender)
        }
        
        else {
            performSegueWithIdentifier("Show Login", sender: sender)
        
        }
        
    }
    
    
    func isLoggedtoInstagram() -> Bool {
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if storage.cookies?.count > 0 {
            return true
        }
            else {
                return false
            }
    }

    
}
