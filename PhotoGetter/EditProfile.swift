//
//  EditProfile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/26/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class EditProfile: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, GalleryDelegate {
    
    @IBOutlet weak var editProfileTable: UITableView!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var profilePicture: UIImageView!
    
    
    @IBOutlet weak var chamgePhoto: UIButton!
    
    var user: InstaUser = InstaUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editProfileTable.delegate = self
        self.editProfileTable.dataSource = self
        
        self.prepareUI()
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isEdited") {
            self.showUserFromDB()
        }
        else {
            self.showUserFromServer()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell", forIndexPath: indexPath) as! EditProfileCell
        
        switch indexPath.row {
        case 0:
            if self.user.username == "" {
                cell.textField.placeholder = "username"
            }
            else {
                cell.textField.text = self.user.username
            }
            break
        case 1:
            if self.user.fullName == "" {
                cell.textField.placeholder = "full name"
            }
            else {
                cell.textField.text = self.user.fullName
            }
            break
        case 2:
            if self.user.bio == "" {
                cell.textField.placeholder = "bio"
            }
            else {
                cell.textField.text = self.user.bio
            }
            break
        case 3:
            if self.user.website == "" {
                cell.textField.placeholder = "website"
            }
            else {
                cell.textField.text = self.user.website
            }
        default:
            break
        }
        return cell
    }
    
    
    @IBAction func cancelEditing(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveEditedUser(sender: AnyObject) {
        if !self.verifyFieldsNotEmpty() {
            return
        }
        else {
            print("Edited \(self.isEdited())")
                if self.isEdited() {
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "isEdited")
                    
                    if NSUserDefaults.standardUserDefaults().boolForKey("isEdited") {
                        CoreDataManager.sharedInstance.updateUser(self.editedUser())
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    else {
                    CoreDataManager.sharedInstance.saveNewUser(self.editedUser())
                    self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
        
        }
        
    }
    
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.editProfileTable.reloadData()
            
        })
        
    }
    
    
    func editedUser() -> InstaUser {
        let editedUser = InstaUser()
        var cells = self.editProfileTable.visibleCells as! [EditProfileCell]
        editedUser.id = NSUserDefaults.standardUserDefaults().stringForKey("id")!
        editedUser.username = cells[0].textField.text!
        editedUser.fullName = cells[1].textField.text!
        editedUser.bio = cells[2].textField.text!
        editedUser.website = cells[3].textField.text!
        return editedUser
    
    }
    
    func verifyFieldsNotEmpty() -> Bool {
        let cells = self.editProfileTable.visibleCells as! [EditProfileCell]
        return cells[0].textField.text?.characters.count > 0
//            && cells[1].textField.text?.characters.count > 0
//            && cells[2].textField.text?.characters.count > 0
//            && cells[3].textField.text?.characters.count > 0
    
    }
    
    func isEdited() -> Bool {
        return self.editedUser().username != self.user.username || self.editedUser().fullName != self.user.fullName || self.editedUser().bio != self.user.bio || self.editedUser().website != self.user.website
    }
    
    func prepareUI() {
        Utils.makeImageRound(self.profilePicture)
    }
    
    
    
    
    func showUserFromDB() {
        self.user = CoreDataManager.sharedInstance.getUserById(self.user.id)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //add profile picture
            if (CacheManager.sharedInstance.objectForKey(self.user.profilePicture) != nil) {
                self.profilePicture.image = CacheManager.sharedInstance.objectForKey(self.user.profilePicture) as? UIImage
                self.reloadTable()
            }
            else {
                Utils.loadImage(self.user.profilePicture, completion: { (image, loaded) in
                    if loaded {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            self.profilePicture.image = image })
                        self.reloadTable()
                    }
                    else {
                        return
                    }
                })
                
            }
        })
        
    }
    
    
    func showUserFromServer() {
        InstagramAPIManager.apiManager.getUserInfoById(user.id, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
            
            if success {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.user = user!
                    
                    //add profile picture
                    if (CacheManager.sharedInstance.objectForKey(user!.profilePicture) != nil) {
                        self.profilePicture.image = CacheManager.sharedInstance.objectForKey(user!.profilePicture) as? UIImage
                        self.reloadTable()
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
                        self.reloadTable()
                    }
                })
                
                
            }
                
            else {
                return
            }
        })
    }
    
   
    @IBAction func changePhoto(sender: AnyObject) {
        let galleryPhotoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GalleryCameraViewController") as! GalleryCameraViewController
        galleryPhotoViewController.delegate = self
        self.presentViewController(galleryPhotoViewController, animated: true, completion: nil)
    }
    
    func imageAssetChoosen(image: UIImage!) {
        dispatch_async(dispatch_get_main_queue(), {
            self.profilePicture.image = image
        });
    }


}
