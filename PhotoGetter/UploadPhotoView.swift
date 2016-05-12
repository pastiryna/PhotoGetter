//
//  UploadPhotoView.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/10/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class UploadPhotoView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {

    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var galleryTab: UITabBarItem!
    @IBOutlet weak var cameraTab: UITabBarItem!
    @IBOutlet weak var container: UIView!
    
    var imagePicker = UIImagePickerController()
    
    
    var viewInContainer: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.delegate = self
        self.navigationController?.delegate = self
        self.showViewControllerInContainer("UploadFromGallery")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        imagePicker.delegate = self
        self.showViewControllerInContainer("UploadFromGallery")
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if (item.tag == 0) {
            self.showViewControllerInContainer("UploadFromGallery")
        }        
        else if (item.tag == 1) {
            self.showViewControllerInContainer("UploadFromGallery")
        }
   
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func showViewControllerInContainer(storyboardId: String) {
        self.hidesBottomBarWhenPushed = false
        self.viewInContainer = (storyboard?.instantiateViewControllerWithIdentifier(storyboardId))! as UIViewController
        self.addChildViewController(viewInContainer)
        self.container.addSubview(viewInContainer.view)
        viewInContainer.didMoveToParentViewController(self)
    }
    
    
    
    
}
