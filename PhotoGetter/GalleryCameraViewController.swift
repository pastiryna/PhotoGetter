//
//  GalleryCameraViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/12/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class GalleryCameraViewController: BaseViewController, UIPageViewControllerDataSource, UITabBarDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var galleryCameraTabBar: UITabBar!
    @IBOutlet weak var galleryCameraContainer: UIView!
    
    
    @IBOutlet weak var galleryBarItem: UITabBarItem!
    @IBOutlet weak var cameraBarItem: UITabBarItem!
    
    var contentViewController = BaseViewController()
    var pageViewController: UIPageViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.galleryCameraTabBar.delegate = self
        
        self.galleryCameraTabBar.barTintColor = Constants.BRAND_COLOR
        self.galleryCameraTabBar.tintColor = Constants.SELECTED_ICON_COLOR

        
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GalleryCameraPageViewController") as! UIPageViewController
        self.pageViewController.dataSource = self
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: false, completion: nil)
        self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        self.pageIndex = 0
        self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.galleryCameraTabBar.frame.size.height)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        //self.galleryCameraContainer.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        self.galleryCameraTabBar.selectedItem = self.galleryBarItem
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
//        var index = (viewController as! BaseViewController).pageIndex
//        self.setItemSelected(index)
//        if index  == 0 {
//            return nil
//        }
//        else {
//            index = index - 1
//            
//            return self.viewControllerAtIndex(index)
//            
//        }
        return nil
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
//        var index = (viewController as! BaseViewController).pageIndex
//        self.setItemSelected(index)
//        print("Current pageIndex \(index)")
//        if index == 1 {
//            return nil
//        }
//        else {
//            index = index + 1
//        }
//        
//        return self.viewControllerAtIndex(index)
        return nil
        
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
//    func viewControllerAtIndex(index: Int) -> BaseViewController {
//        if index == 0 {
//            self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GalleryViewController") as! BaseViewController
//            self.contentViewController.pageIndex = index }
//        else {
//            self.contentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CameraViewController") as! BaseViewController
//            self.contentViewController.pageIndex = index
//        }
//        
//        return self.contentViewController
//    }
    
//    func setItemSelected(index: Int) {
//        if index == 0 {
//            self.galleryCameraTabBar.selectedItem = self.galleryBarItem
//        }
//        else if index == 1 {
//            self.galleryCameraTabBar.selectedItem = self.cameraBarItem
//                }
//        else {
//            return
//        }
//        
//    }

    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        let currentIndex = self.pageIndex
        
        if currentIndex == item.tag {
            return
        }
        else if currentIndex < item.tag {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
            self.pageIndex = item.tag
        }
        else {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            self.pageIndex = item.tag
        
        }
        
//        if item.tag == 0 {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
//            self.pageIndex = item.tag
//        
//        }
//        else {
//            var imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//            self.pageViewController.setViewControllers([imagePicker], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
//            self.pageIndex = item.tag
//}
        
    }


    
    
}
