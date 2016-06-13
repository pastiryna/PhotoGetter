//
//  PhotoComments.swift
//  PhotoGetter
//
//  Created by IrynaP on 6/3/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit


class PhotoComments: BaseViewController, UITextFieldDelegate {

    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var postComment: UIButton!
        
    var commentProvider: CommentProvider = CommentProvider()
    var photoUrl: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = Constants.BRAND_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.commentField.delegate = self
        
        self.commentTable.delegate = commentProvider
        self.commentTable.dataSource = commentProvider
        
        
       

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoComments.keyboardWillShowNotification(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(PhotoComments.keyboardWillHideNotification(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = false
        ///self.bottomConstraint.constant = 400
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.commentField.resignFirstResponder()
        self.bottomConstraint.constant = 0
        return true
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).unsignedIntValue << 16
        let animationCurve = UIViewAnimationOptions(rawValue: UInt(rawAnimationCurve))
        
      
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.bottomConstraint.constant = CGRectGetMaxY(self.view.bounds) - CGRectGetMinY(convertedKeyboardEndFrame)
            }, completion: nil)
    }
    
    @IBAction func postComment(sender: AnyObject) {
        
        //update existing or add new
        if let comment = self.commentField.text {
             CoreDataManager.sharedInstance.addCommentToPhoto(comment, photoUrl: self.photoUrl!)
             //self.view.endEditing(true)
            self.commentField.resignFirstResponder()
            self.bottomConstraint.constant = 0
            self.commentField.text = ""
             self.reloadTable()
        }
        else {
            self.reloadTable()
            return
        }
    }
    
    func reloadTable() {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.commentTable.reloadData()
        
        })
    
    }
    
    
    
    


}
