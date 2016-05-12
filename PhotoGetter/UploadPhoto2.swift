//
//  UploadPhoto2.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/10/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class UploadPhoto2: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarDelegate {
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.uploadFromGallery()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
       
        imagePicker.view.frame = self.view.bounds

        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
//    func uploadFromCamera() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
//            self.imagePicker = UIImagePickerController()
//            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
//            imagePicker.view.frame = self.view.bounds
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//        
//        
//    }
//    
//    func uploadFromGallery() {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
//            self.imagePicker = UIImagePickerController()
//            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//            //imagePicker.modalPresentationStyle = UIModalPresentationStyle.
//            imagePicker.view.frame = self.view.bounds
//            self.presentViewController(imagePicker, animated: true, completion: nil)
//        }
//        
//        
//    }
    

    
}
