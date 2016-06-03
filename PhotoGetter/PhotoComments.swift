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
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = Constants.BRAND_COLOR
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        self.commentField.delegate = self

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.navigationController?.navigationBar.hidden = false
        self.bottomConstraint.constant = 400
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.commentField.resignFirstResponder()
        return true
    }
    }
