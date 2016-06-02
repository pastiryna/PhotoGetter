//
//  GalleryCameraViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/12/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

protocol GalleryDelegate {
    func imageAssetChoosen(image: UIImage!, imagePath: String)
}

class GalleryCameraViewController: BaseViewController, UIPageViewControllerDataSource, UITabBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var galleryCameraTabBar: UITabBar!
    @IBOutlet weak var galleryCameraContainer: UIView!
    
    
    @IBOutlet weak var galleryBarItem: UITabBarItem!
    @IBOutlet weak var cameraBarItem: UITabBarItem!
    
    var delegate: GalleryDelegate! = nil
    var contentViewController = BaseViewController()
    var pageViewController: UIPageViewController!
    var imagePicker: UIImagePickerController!
    var cameraPicker: UIImagePickerController!
    var pickedImage: UIImage?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryCameraTabBar.delegate = self
        
        self.galleryCameraTabBar.barTintColor = Constants.BRAND_COLOR
        self.galleryCameraTabBar.tintColor = Constants.SELECTED_ICON_COLOR

        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GalleryCameraPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        imagePicker.allowsEditing = true
        
        cameraPicker.sourceType = UIImagePickerControllerSourceType.Camera
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        //self.presentViewController(imagePicker, animated: false, completion: nil)
        self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.pageIndex = 0
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.galleryCameraTabBar.frame.size.height)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        //self.galleryCameraContainer.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.galleryCameraTabBar.selectedItem = self.galleryBarItem
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
//        let imagePicker =  UIImagePickerController()
//        imagePicker.sourceType = .PhotoLibrary
//        self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        return nil
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let currentIndex = self.pageIndex
        
        if currentIndex == item.tag {
            return
        }
        else if currentIndex < item.tag {
            pageViewController.setViewControllers([cameraPicker], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
            self.pageIndex = item.tag
        }
        else {
            self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            self.pageIndex = item.tag
        
        }
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.pickedImage = image
            print("URL \(info[UIImagePickerControllerReferenceURL]?.absoluteString)")
            let path: String = info[UIImagePickerControllerReferenceURL]!.absoluteString
            if self.delegate != nil {
                self.delegate.imageAssetChoosen(self.pickedImage, imagePath: path)
            }
            dismissViewControllerAnimated(true, completion: nil)

        }
        else if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.pickedImage = image
            if self.delegate != nil {
                let path = info[UIImagePickerControllerReferenceURL]?.absoluteString
                print("ASSET Path \(path)")
                self.delegate.imageAssetChoosen(self.pickedImage, imagePath: path!)
            }
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Nothing has been picked")
            return
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
   
    
}
