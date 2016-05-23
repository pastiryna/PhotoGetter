//
//  BaseViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    var pageIndex: Int!
    
    
    
    let urlForCode = "https://api.instagram.com/oauth/authorize/?client_id=6080917e427b4c6599b0056fc5ce54da&redirect_uri=http://mysupertestapp.com/&response_type=code"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)        
    }
    
    func showLoader(text: String) {
        dispatch_async(dispatch_get_main_queue(), {
            let loader = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loader.labelText = text
            loader.userInteractionEnabled = false
        })
    }
    
    func hideLoader() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        })
    }
    
   
        
  
   

}
