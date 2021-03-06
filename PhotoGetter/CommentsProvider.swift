//
//  CommentsProvider.swift
//  PhotoGetter
//
//  Created by IrynaP on 6/10/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import Foundation
import UIKit



class CommentProvider: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var comments: [String]?
    var commentsOnFeed: Bool = false
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        if self.comments == nil {
//            return 0
//        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.commentsOnFeed {
            return 20
        }
        return 30
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.commentsOnFeed {
            if self.comments == nil {
                return 1
            }
            else if self.comments?.count > 2 {
                return 2
            }
        }
        else {
        
        if self.comments == nil {
            return 1
        }
    }
        return comments!.count

        
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EmbeddedCommentCell") as! EmbeddedCommentCell
        
        if self.comments?.count > 0 {
             cell.commentLabel.text = self.comments![indexPath.row]
        }
        else if comments == nil {
            cell.commentLabel.text = "comment"
        }
        
        return cell
    }
    
    

    




}