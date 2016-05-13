//
//  GalleryViewController.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/13/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class GalleryViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func showGallery() {
        
        
    }
    
    func openGallery() {
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    
    }
    
    
}