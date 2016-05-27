//
//  EditProfile.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/26/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class EditProfile: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var editProfileTable: UITableView!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var user: InstaUser = InstaUser()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.editProfileTable.delegate = self
        self.editProfileTable.dataSource = self
        //self.user.id = NSUserDefaults.standardUserDefaults().stringForKey("id")!
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isEdited") {
            self.user = CoreDataManager.sharedInstance.getUserById(self.user.id)
            print(self.user.username)
            print(self.user.fullName)
           print("here")
        }
        
        else {            
            InstagramAPIManager.apiManager.getUserInfoById(self.user.id, accessToken: NSUserDefaults.standardUserDefaults().stringForKey("accessToken")!, completion: { (user, success) in
                if success {
                    self.user = user!
                    self.reloadTable()
                }
                else {
                    self.reloadTable()
                }
                
           })
        }
    
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
            cell.textField.text = self.user.username
            break
        case 1:
            cell.textField.text = self.user.fullName
            break
        case 2:
             cell.textField.text = self.user.bio
        case 3:
             cell.textField.text = self.user.website
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
}
