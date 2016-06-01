//
//  Profile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit



class Profile: BaseViewController, UIPageViewControllerDataSource, UINavigationBarDelegate {

    @IBOutlet weak var switchToCollectionButton: UIButton!
    @IBOutlet weak var switchToTableButton: UIButton!
    
    @IBOutlet weak var profileContainer: UIView!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var postCountButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var editButtonWidthConstraint: NSLayoutConstraint!
    
    
    var viewWithTable: ViewWithTable!
    //var collectionView: ProfileCollectionViewController?
    var pageViewController: UIPageViewController!
    var contentPageViewControllers: [UIViewController]!
    var user: InstaUser = InstaUser()
    var followersUrl: String!
    var followingUrl: String!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accessTok = NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!
        self.followingUrl = "https://api.instagram.com/v1/users/\(self.user.id)/follows?access_token=\(accessTok)"
        self.followersUrl = "https://api.instagram.com/v1/users/\(self.user.id)/followed-by?access_token=\(accessTok)"
    
       
        self.navigationController?.navigationBarHidden = false
        self.hidesBottomBarWhenPushed = false
        self.navigationController?.navigationBar.barTintColor = Constants.BRAND_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.prepareUI()

        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ProfilePageViewController") as! UIPageViewController
        self.pageViewController.view.frame = CGRectMake(0, 0, self.profileContainer.frame.width, self.profileContainer.frame.height)
        
        self.pageViewController.dataSource = self
        
        let firstPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileCollectionViewController") as! ProfileCollectionViewController
        firstPage.user.id = self.user.id
        
        let secondPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewWithTable") as! ViewWithTable
        secondPage.user.id = self.user.id
        self.contentPageViewControllers = [firstPage, secondPage]
        
        self.pageViewController.setViewControllers([self.contentPageViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.addChildViewController(self.pageViewController)
        self.profileContainer.addSubview(self.pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
//        
//        if CoreDataManager.sharedInstance.isSaved(self.user) { 
//           self.showUserFromDB()
//            
//        }
//        
//        else {
            self.showUserFromServer()
      //  }
        
}
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBarHidden = false
        
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
        self.clearCache()

    }
    
    
    @IBAction func switchContainerView (sender: UIButton) {
        
        if sender == self.switchToTableButton {
            self.navigationController?.navigationBarHidden = false
            self.switchToCollectionButton.setFATitleColor(UIColor.grayColor())
            self.switchToTableButton.setFATitleColor(UIColor.blueColor())
            self.navigationController?.navigationBarHidden = false
            self.pageViewController.setViewControllers([self.contentPageViewControllers[1]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
           
        }
        
        else if sender == self.switchToCollectionButton {
               self.navigationController?.navigationBarHidden = false
               self.switchToTableButton.setFATitleColor(UIColor.grayColor())
               self.switchToCollectionButton.setFATitleColor(UIColor.blueColor())
               self.pageViewController.setViewControllers([self.contentPageViewControllers[0]], direction: UIPageViewControllerNavigationDirection.Reverse, animated: false, completion: nil)
               
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Followers" {
            let followersViewController = segue.destinationViewController as! FollowersList
            followersViewController.url = self.followersUrl
            followersViewController.title = "FOLLOWERS"
        }
        else if segue.identifier == "Following" {
            let followingViewController = segue.destinationViewController as! FollowersList
            followingViewController.url = self.followingUrl
            followingViewController.title = "FOLLOWING"
        }
        else if segue.identifier == "EditProfile" {
            let editProfile = segue.destinationViewController as! EditProfile
            editProfile.user.id = self.user.id
            
        
        }
        
    }
    
    func clearCache() {
        CacheManager.sharedInstance.removeAllObjects()
    }
    
    func showUserFromDB() {
        self.user = CoreDataManager.sharedInstance.getUserById(self.user.id)
         dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.navigationController?.title = self.user.username.uppercaseString
            self.bioLabel.text = self.user.fullName })
        
        self.showFollowers(self.user.id)
        
       
        
        //profile picture
        
    
    
    }
    
    func showUserFromServer() {
        InstagramAPIManager.apiManager.getUserInfoById(user.id, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                     self.navigationController?.navigationBar.topItem?.title = user!.username.uppercaseString
                    self.bioLabel.text = user!.fullName
                    
                    let followers = NSMutableAttributedString(string: "\(user!.numberOfFollowers)\nfollowers")
                    self.followersButton.setAttributedTitle(followers, forState: UIControlState.Normal)
                    
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
    
    func prepareUI() {
        Utils.makeImageRound(self.profilePicture)
        self.editProfileButton.backgroundColor = Constants.BRAND_COLOR
        
        self.settingsButton.setFAIcon(FAType.FACog, iconSize: 20)
        self.settingsButton.tintColor = UIColor.whiteColor()
        
        self.switchToTableButton.setFAIcon(FAType.FAAlignJustify, forState: .Normal)
        self.switchToCollectionButton.setFAIcon(FAType.FATh, forState: .Normal)
        self.switchToCollectionButton.setFATitleColor(UIColor.blueColor())

        
        if self.user.id != NSUserDefaults.standardUserDefaults().stringForKey("id") {
            self.editProfileButton.hidden = true
        }
        else {
            self.editProfileButton.hidden = false
        }
        
        let screenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
        let width: CGFloat = 20*2 + 0.45*screenWidth
        
        editButtonWidthConstraint.constant = width
        self.view.layoutSubviews()
    }
    
    func showFollowers(userId: String) {
        InstagramAPIManager.apiManager.getUserInfoById(userId, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    let followers = NSMutableAttributedString(string: "\(user!.numberOfFollowers)\nfollowers")
                    self.followersButton.setAttributedTitle(followers, forState: UIControlState.Normal)
                    
                    let following = NSMutableAttributedString(string: "\(user!.numberFollowing)\nfollowing")
                    self.followingButton.setAttributedTitle(following, forState: UIControlState.Normal)
                    
                    let posts = NSMutableAttributedString(string: "\(user!.numberOfPosts)\nposts")
                    self.postCountButton.setAttributedTitle(posts, forState: UIControlState.Normal)
    
                })
            }
        })
    }
    
   

}

