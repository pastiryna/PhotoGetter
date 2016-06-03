//
//  LoginWebView.swift
//  PhotoGetter
//
//  Created by IrynaP on 4/20/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import MBProgressHUD


class LoginWebView: BaseViewController, UIWebViewDelegate {
    
    @IBOutlet weak var loginWebView: UIWebView!
    @IBOutlet weak var closeWebView: UIBarButtonItem!
    
    
    let REDIRECT_URI = "http://mysupertestapp.com/"
    let CLIENT_ID = "6080917e427b4c6599b0056fc5ce54da"
    let CLIENT_SECRET = "0c490f39cc7143d083bdd5a2b0be33f9"

    
    
    
    //https://api.instagram.com/oauth/authorize/?client_id=6080917e427b4c6599b0056fc5ce54da&redirect_uri=http://mysupertestapp.com/&response_type=code
    
    var typeOfAuth: NSString = ""
    var authUrl: String = ""
    var responseCode: String = ""
    
    
    override func viewDidAppear(animated: Bool) {
       super.viewDidAppear(true)
       self.navigationController?.navigationBarHidden = false
        
              /*if (typeOfAuth .isEqualToString("UNSIGNED")) {
            authUrl = "https://api.instagram.com/oauth/authorize/?client_id=\(CLIENT_ID)&redirect_uri=\(REDIRECT_URI)&response_type=token"
        }
        
        else {*/
            authUrl = "https://api.instagram.com/oauth/authorize/?client_id=\(CLIENT_ID)&redirect_uri=\(REDIRECT_URI)&response_type=code"
        
        
    
        
      //authUrl = "https://api.instagram.com/oauth/authorize/?client_id=6080917e427b4c6599b0056fc5ce54da&redirect_uri=http://mysupertestapp.com/&response_type=code"
            
        let nsUrl = NSURL(string: authUrl)
        let request = NSURLRequest(URL: nsUrl!)
        
        self.loginWebView.delegate = self
        self.loginWebView.scalesPageToFit = true
        
        
        self.loginWebView.loadRequest(request)
        print("Login should be shown")
       // self.clearCookies()
       
        
       
}
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false

    }

    func webView( _webView: UIWebView,
        shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
            
            let urlString: NSString = request.URL!.absoluteString
            print("URLString:\(urlString)")
            
            if (urlString.hasPrefix(REDIRECT_URI)) {
                if (urlString.containsString("code")) {
                    let range = urlString.rangeOfString("code")
                    print("RangeOfCode: \(range)")
                    responseCode = urlString.substringFromIndex(range.length+(range.location+1))
                    print("ResponseCode: \(responseCode)")
                    InstagramAPIManager.apiManager.makePostWithCodeForToken(responseCode, completion: { (accessToken, success) -> Void in
                        if success {
                            self.performSegueWithIdentifier("Show Table After Login", sender: self)
                            InstagramAPIManager.apiManager.accessToken = accessToken
                            NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
                            //InstagramAPIManager.apiManager.setUserDefaults(<#T##userDict: NSDictionary##NSDictionary#>)
                        }
                        })
                    
                    return false
                }
            }
   
            return true
    }
    
    
    @IBAction func closeLoginScreen(sender: UIBarButtonItem) {
        clearCookies()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func clearCookies() {
        let storage : NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        if storage.cookies?.count > 0 {
            for cookie in storage.cookies! as [NSHTTPCookie] {
                storage.deleteCookie(cookie)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.showLoader("Opening...")
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hideLoader()

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




