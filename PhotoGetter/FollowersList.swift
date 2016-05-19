//
//  FollowersList.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/19/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit

class FollowersList: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var followersTableView: UITableView!
  
    
    var users: [InstaUser]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.followersTableView.delegate = self
        self.followersTableView.dataSource = self
        
    }
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FollowCell", forIndexPath: indexPath) as! FollowCell
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (self.followersTableView.frame.size.height / 8)
    }
    

}
