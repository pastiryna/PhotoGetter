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
    
    
    var picked: UIImage?
    
    
    
   
    
    var user: InstaUser = InstaUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editProfileTable.delegate = self
        self.editProfileTable.dataSource = self
        
        self.prepareUI()
        
        if CoreDataManager.sharedInstance.isSaved(self.user) {
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
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.editProfileTable.frame.size.height * 0.2
        }
        else {
            return self.editProfileTable.frame.size.height * 0.1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        switch indexPath.row {
        case 0:
            let editCell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell", forIndexPath: indexPath) as! EditProfileCell
            Utils.makeImageRound(editCell.profilePicture)
            
            if self.picked != nil {
                editCell.profilePicture.image = self.picked
                self.picked = nil
            }
            else {
                
                if (CacheManager.sharedInstance.objectForKey(self.user.profilePicture) != nil) {
                    editCell.profilePicture.image = CacheManager.sharedInstance.objectForKey(self.user.profilePicture) as? UIImage
                    
                }
                else {
                    Utils.loadImage(self.user.profilePicture, completion: { (image, loaded) in
                        if loaded {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                editCell.profilePicture.image = image })

                        }
                    })
                }
            }
            if self.user.username == "" {
                editCell.usernameTextField.placeholder = "username"
            }
            else {
                editCell.usernameTextField.text = self.user.username
            }
            if self.user.fullName == "" {
                editCell.fullNameTextField.placeholder = "full name"
            }
            else {
                editCell.fullNameTextField.text = self.user.fullName
            }
            cell = editCell
            break
        case 1:
            let editCell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell2", forIndexPath: indexPath) as! EditProfileCell2
            if self.user.bio == "" {
                editCell.textField.placeholder = "bio"
            }
            else {
                editCell.textField.text = self.user.bio
            }
            cell = editCell
            break
        case 2:
            let editCell = tableView.dequeueReusableCellWithIdentifier("EditProfileCell2", forIndexPath: indexPath) as! EditProfileCell2
            if self.user.website == "" {
                editCell.textField.placeholder = "website"
            }
            else {
                editCell.textField.text = self.user.website
            }
            cell = editCell
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
                   
                    
                    if CoreDataManager.sharedInstance.isSaved(self.user) {
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
        var cells = self.editProfileTable.visibleCells 
        editedUser.id = NSUserDefaults.standardUserDefaults().stringForKey("id")!
        editedUser.username = (cells[0] as! EditProfileCell).usernameTextField.text!
        editedUser.fullName = (cells[0] as! EditProfileCell).fullNameTextField.text!
        editedUser.bio = (cells[1] as! EditProfileCell2).textField.text!
        editedUser.website = (cells[2] as! EditProfileCell2).textField.text!
        return editedUser
    
    }
    
    func verifyFieldsNotEmpty() -> Bool {
        let cells = self.editProfileTable.visibleCells 
        return (cells[0] as! EditProfileCell).usernameTextField.text?.characters.count > 0
//            && cells[1].textField.text?.characters.count > 0
//            && cells[2].textField.text?.characters.count > 0
//            && cells[3].textField.text?.characters.count > 0
    
    }
    
    func isEdited() -> Bool {
        return self.editedUser().username != self.user.username || self.editedUser().fullName != self.user.fullName || self.editedUser().bio != self.user.bio || self.editedUser().website != self.user.website
    }
    
    func prepareUI() {
        self.topBar.backgroundColor = Constants.BRAND_COLOR
        self.topBar.barTintColor = Constants.BRAND_COLOR
    }
    
    
    
    
    func showUserFromDB() {
        self.user = CoreDataManager.sharedInstance.getUserById(self.user.id)
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //add profile picture
            if (CacheManager.sharedInstance.objectForKey(self.user.profilePicture) != nil) {
               // self.profilePicture.image = CacheManager.sharedInstance.objectForKey(self.user.profilePicture) as? UIImage
                self.reloadTable()
            }
            else {
                Utils.loadImage(self.user.profilePicture, completion: { (image, loaded) in
                    if loaded {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                          //  self.profilePicture.image = image
                        })
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
                        //self.profilePicture.image = CacheManager.sharedInstance.objectForKey(user!.profilePicture) as? UIImage
                        self.reloadTable()
                    }
                    else {
                        Utils.loadImage(user!.profilePicture, completion: { (image, loaded) in
                            if loaded {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                   // self.profilePicture.image = image
                                })
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
    
   
    
    func imageAssetChoosen(image: UIImage!) {
        dispatch_async(dispatch_get_main_queue(), {
            self.picked = image
            self.reloadTable()
        });
    }

    @IBAction func changePhoto(sender: AnyObject) {
        let galleryPhotoViewController = self.storyboard?.instantiateViewControllerWithIdentifier("GalleryCameraViewController") as! GalleryCameraViewController
        galleryPhotoViewController.delegate = self
        self.presentViewController(galleryPhotoViewController, animated: true, completion: nil)

    }

    
}
