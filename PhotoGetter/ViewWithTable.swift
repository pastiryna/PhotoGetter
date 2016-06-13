//
//  ViewWithTable.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/4/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ScrollDelegate {
    func tableWasScrolled(scrollView: UIScrollView)
}


class ViewWithTable: BaseViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var photoTable: PhotoGetterTableView!
    @IBOutlet weak var feedBarItem: UITabBarItem!   
    @IBOutlet var openCommentsGesture: UITapGestureRecognizer!

   
    let user_id = "3152442007"
    var photoUrls: [String] = []
    let acc_tok = "3152442007.6080917.b6d6d78fd7d943b8bd86ca07258a5336"
    var loaded = false
    let date: Double = 1462529472
    var refreshControl: UIRefreshControl = UIRefreshControl()
    var footerRefresh = UIRefreshControl()
    var numberOfRows = 2
    var isLoading = false
    var user = InstaUser()
    var scrollDelegate: ScrollDelegate! = nil
    var commentProvider: CommentProvider = CommentProvider()
    
    let mario = "http://www.imagenspng.com.br/wp-content/uploads/2015/02/small-super-mario.png"
    var userPhotos: [UserPhoto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTable.delegate = self
        photoTable.dataSource = self
        
        self.openCommentsGesture.delegate = self
        //self.openCommentsGesture.view?.tag = 0
       
        
        self.reloadTable()
        
        self.showLoader("Loading...")
        
        self.navigationController!.navigationBar.hidden = false

        self.hidesBottomBarWhenPushed = false
        self.navigationController!.navigationBar.barTintColor = Constants.BRAND_COLOR
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]

        
        self.refreshControl.addTarget(self, action: #selector(ViewWithTable.refreshHandler), forControlEvents: UIControlEvents.ValueChanged)
        self.photoTable.addSubview(self.refreshControl)
        
//       self.photoTable.tableFooterView?.addSubview(self.footerRefresh)
         self.photoTable.tableFooterView?.hidden = false
        
        self.commentProvider.comments = CoreDataManager.sharedInstance.getAllComments()
        //self.commentProvider.photoUrls = self.photoUrls
        self.refreshData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.reloadTable()
        self.navigationController?.navigationBar.hidden = false

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.reloadTable()
        self.navigationController?.navigationBar.hidden = false

    }    
        
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.view.frame.width * 1.5)
    }
    
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return self.footerRefresh
//    }
//    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.photoUrls.count < self.numberOfRows {
            return self.photoUrls.count
        }
        else {
            print("Number of rows \(self.numberOfRows)")
            return self.numberOfRows
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath: indexPath) as! NewCell
        cell.heartButton.tag = indexPath.row
        //self.openCommentsGesture.view?.tag = indexPath.row
        cell.tag = indexPath.row
        cell.heartButton.setFAIcon(FAType.FAHeart, iconSize: 30, forState: UIControlState.Normal)
        cell.heartButton.setFATitleColor(self.heartColor(indexPath.row))
        
        let photoUrl = self.photoUrls[indexPath.row]
        if (CacheManager.sharedInstance.objectForKey(photoUrl) != nil) {
            cell.photo.image = CacheManager.sharedInstance.objectForKey(photoUrl) as? UIImage
            
            cell.photoTitleLabel.text = self.userPhotos[indexPath.row].timePassed()
            print("Date \(self.userPhotos[indexPath.row].timePassed())")
            print("Cashed Image for row \(indexPath.row)")
        }
        else {
            Utils.loadImage(photoUrl, completion: { (image, loaded) -> Void in
                if loaded {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                       // self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 49)
                         //let imageWidth = self.view.frame.width
                        
                         cell.photo.image = image
                       
                        cell.photoTitleLabel.text = NSUserDefaults.standardUserDefaults().stringForKey("username")
                        cell.photoTitleLabel.text = self.userPhotos[indexPath.row].timePassed()
                        print("Date \(self.userPhotos[indexPath.row].timePassed())")
                    })
                    
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        let current = UIImage(named: "defaultImage")!
                        cell.photo.image = current
                        cell.photoTitleLabel.text = "defaultImage"
                    })
                }
            })
        }
        //add comments to cell:
        
        
        //cell.commentsTable.delegate = cell
        //cell.commentsTable.tag = indexPath.row
        //cell.commentsTable.dataSource = cell
        
        
        cell.commentsTable.tag = indexPath.row
        cell.commentsTable.delegate = self.commentProvider
        cell.commentsTable.dataSource = self.commentProvider
        commentProvider.comments = CoreDataManager.sharedInstance.getPhotoComments(self.photoUrls[indexPath.row])
       // commentProvider.commentsOnFeed = true
        cell.commentsTable.reloadData()
       
        
        return cell
 
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.photoTable.reloadData()
            
        })
    
    }
    
    func refreshData() {
        InstagramAPIManager.apiManager.getUserPhotosById(self.user.id, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: {(photos, success) -> Void in
            self.hideLoader()
            if (success) {
                self.photoUrls = []
                self.userPhotos = photos
                for i in photos {
                    self.photoUrls.append(i.getUrl()) }
                self.numberOfRows = 2
                self.reloadTable()
            }
                
            else {
                self.photoUrls = [String]()
                self.reloadTable()
            }
            
        })
}
    
    func refreshHandler() {
        self.refreshData()
        self.reloadTable()
        self.refreshControl.endRefreshing()
    
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.scrollDelegate != nil {
            self.scrollDelegate.tableWasScrolled(scrollView)}
        
        let currentOffset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let deltaOffset = currentOffset - maxOffset
        
        if deltaOffset <= 0 {
            //self.numberOfRows += 1
            self.loadMore()
            
        }
    }
    
    func loadMore() {
        if ( !isLoading ) {
            self.isLoading = true
            //self.photoTable.tableFooterView?.hidden = false
            //self.footerRefresh.beginRefreshing()
            //self.refreshControl.startAnimating()
            
            
            loadMoreBegin({ (success) in
                if success {
                    self.photoTable.reloadData()
                    self.isLoading = false
                     //self.photoTable.tableFooterView?.hidden = false
                    //self.refreshControl.endRefreshing()
                    //self.activityIndicator.stopAnimating()
                    //self.photoTable.tableFooterView?.hidden = true
                }
            })
        }
    }
    
        func loadMoreBegin(loadMoreEnd: (success: Bool) -> Void) {
            //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.numberOfRows += 2
                loadMoreEnd(success: true) })
            
//                sleep(2)
//            }
//            dispatch_async(dispatch_get_main_queue()) {
//                loadMoreEnd(success: true)
            
        }
//    
//    func changeNumberOfRows() {
//        if self.numberOfRows - self.
//    }
    
    @IBAction func like(sender: AnyObject) {
        let index = sender.tag
       // print(index)
       //print(self.numberOfRows)
       
        if !CoreDataManager.sharedInstance.isPhotoLiked(self.photoUrls[index]) {
            (sender as! UIButton).setFATitleColor(UIColor.redColor())
            //cell.heartButton.setFATitleColor(UIColor.redColor())
            CoreDataManager.sharedInstance.saveLikedPhoto(self.photoUrls[index])
        }
        else {
            if CoreDataManager.sharedInstance.isLiked(self.photoUrls[index]) {
                (sender as! UIButton).setFATitleColor(UIColor.grayColor())
                //cell.heartButton.setFATitleColor(UIColor.grayColor())
                CoreDataManager.sharedInstance.updatePhoto(self.photoUrls[index], isLiked: false)
                
            }
            else {
               // cell.heartButton.setFATitleColor(UIColor.redColor())
                (sender as! UIButton).setFATitleColor(UIColor.redColor())
                CoreDataManager.sharedInstance.updatePhoto(self.photoUrls[index], isLiked: true)
                
            }
        }
        
    }
    
    func heartColor(index: Int) -> UIColor {
        if CoreDataManager.sharedInstance.isLiked(self.photoUrls[index]) {
            return UIColor.redColor()
        }
        else {
            return UIColor.grayColor() }
    }
    
    
    @IBAction func showComments(sender: AnyObject) {
        let index = sender.view.tag
        print("Index = \(index)")
        let commentsView = self.storyboard?.instantiateViewControllerWithIdentifier("PhotoComments") as! PhotoComments
        commentsView.photoUrl = self.photoUrls[index]        
        commentsView.commentProvider.comments = CoreDataManager.sharedInstance.getPhotoComments(self.photoUrls[index])

        commentsView.navigationController?.navigationBarHidden = false
        commentsView.tabBarController?.tabBar.hidden = true
       // self.navigationController?.presentViewController(comments, animated: true, completion: nil)
        self.navigationController?.viewControllers.append(commentsView)
    
    }

}
