//
//  TabBarView.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/10/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class TabBarView: UIViewController, UITabBarDelegate {
    
    @IBOutlet weak var feedTabItem: UITabBar!
    @IBOutlet weak var addPhotoTabItem: UITabBarItem!
    @IBOutlet weak var profileTabItem: UITabBarItem!
    
    @IBOutlet weak var mainViewContainer: UIView!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        
    }
    
   func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
    if (item.tag == 0) {
        performSegueWithIdentifier("Feed", sender: item) //FeedView
    }
    
    else if (item.tag == 1) {
        performSegueWithIdentifier("Upload Photo", sender: item)
    }
    
    else if (item.tag == 2) {
        performSegueWithIdentifier("Profile", sender: item)
    }
   }
    
    
    func showViewControllerInContainer(storyboardId: String) {
        self.hidesBottomBarWhenPushed = false
        self.viewInContainer = (storyboard?.instantiateViewControllerWithIdentifier(storyboardId))! as UIViewController
        self.addChildViewController(viewInContainer)
        self.container.addSubview(viewInContainer.view)
        viewInContainer.didMoveToParentViewController(self)
    }

    

}
