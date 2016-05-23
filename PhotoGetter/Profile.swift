//
//  Profile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit



class Profile: BaseViewController, UIPageViewControllerDataSource {

    @IBOutlet weak var switchToCollectionButton: UIButton!
    @IBOutlet weak var switchToTableButton: UIButton!
    
    @IBOutlet weak var profileTopBar: UINavigationBar!
    @IBOutlet weak var usernameTopLabel: UILabel!
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var settingsBarItem: UIBarButtonItem!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postCountButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    
    
    
    var viewWithTable: ViewWithTable!
    //var collectionView: ProfileCollectionViewController?
    var pageViewController: UIPageViewController!
    var contentPageViewControllers: [UIViewController]!
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.navigationBarHidden = true
        self.hidesBottomBarWhenPushed = false
        
         
         //make image round
        Utils.makeImageRound(self.profilePicture)
        //make buttons square

        self.settingsBarItem.setFAIcon(FAType.FACog, iconSize: 20)
        self.settingsBarItem.tintColor = UIColor.whiteColor()
        
        self.switchToTableButton.setFAIcon(FAType.FAAlignJustify, forState: .Normal)
        self.switchToCollectionButton.setFAIcon(FAType.FATh, forState: .Normal)
        self.switchToCollectionButton.setFATitleColor(UIColor.blueColor())
       
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfilePageViewController") as! UIPageViewController
        self.pageViewController.view.frame = CGRectMake(0, 0, self.profileContainer.frame.width, self.profileContainer.frame.height)
        
        self.pageViewController.dataSource = self
        
        let firstPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewWithTable") as! ViewWithTable
        //firstPage.view.frame = CGRectMake(0, 0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height)
        
        let secondPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileCollectionViewController") as! ProfileCollectionViewController
        //secondPage.view.frame = CGRectMake(0, 0, self.pageViewController.view.frame.size.width, self.pageViewController.view.frame.size.height)
        self.contentPageViewControllers = [firstPage, secondPage]
        
        self.pageViewController.setViewControllers([self.contentPageViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.profileContainer.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        InstagramAPIManager.apiManager.getUserInfoById(NSUserDefaults.standardUserDefaults().stringForKey("id")!, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.usernameTopLabel.text = user!.username.uppercaseString
                    self.bioLabel.text = user!.fullName
                    
                    let followers = NSMutableAttributedString(string: "\(user!.numberOfFollowers)\nfollowers")
                    self.followersButton.setAttributedTitle(followers, forState: UIControlState.Normal)
                    

                    var numberFollowingAtt = NSMutableAttributedString(string: String(user!.numberFollowing))
                    //var attr = NSFontAttributeName(UIFont.boldSystemFontOfSize(12))
                    
                    
                    let following = NSMutableAttributedString(string: "\(user!.numberFollowing)\nfollowing")
                    self.followingButton.setAttributedTitle(following, forState: UIControlState.Normal)
                    
                    let posts = NSMutableAttributedString(string: "\(user!.numberOfPosts)\nposts")
                    self.postCountButton.setAttributedTitle(posts, forState: UIControlState.Normal)
                    
                    //add profile picture
                    if (CacheManager.sharedInstance.objectForKey(user!.profilePicture) != nil) {
                        self.profilePicture.image = CacheManager.sharedInstance.objectForKey(user!.profilePicture) as? UIImage
                    }
                    else {
                        Utils.loadImage(user!.profilePicture, completion: { (image, loaded) in
                            if loaded {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.profilePicture.image = image })
                            }
                            else {
                                return
                            }
                        })
                        
                    }
                })
                    
           
            }
                    
            else {
                return
            }
        })
}
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        return nil
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
    

    @IBAction func makeLogout(sender: AnyObject) {
        self.clearCookies()

    }
    
    
    @IBAction func switchContainerView (sender: UIButton) {
        
        if sender == self.switchToTableButton {
            self.switchToCollectionButton.setFATitleColor(UIColor.grayColor())
            self.switchToTableButton.setFATitleColor(UIColor.blueColor())
            self.pageViewController.setViewControllers([self.contentPageViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
//            self.viewWithTable = self.storyboard?.instantiateViewControllerWithIdentifier("ViewWithTable") as! ViewWithTable
//            self.viewWithTable.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.profileContainer.frame.size.height)
//            self.addChildViewController(self.viewWithTable)
//            self.profileContainer.addSubview(viewWithTable.view)
//            self.viewWithTable.didMoveToParentViewController(self)
        }
        
        else if sender == self.switchToCollectionButton {
               self.switchToTableButton.setFATitleColor(UIColor.grayColor())
               self.switchToCollectionButton.setFATitleColor(UIColor.blueColor())
               self.pageViewController.setViewControllers([self.contentPageViewControllers[1]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
            
//                self.collectionView = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileCollectionViewController") as! ProfileCollectionViewController
//                self.collectionView!.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.profileContainer.frame.size.height)
//                self.addChildViewController(self.collectionView!)
//                self.profileContainer.addSubview(collectionView!.view)
//                self.collectionView!.didMoveToParentViewController(self)
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Folowers" {
            self.tabBarController?.hidesBottomBarWhenPushed = false
            self.navigationController?.hidesBottomBarWhenPushed = false
        
        }
    }
    
   
    
}
