//
//  UserPhoto.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/10/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import Foundation
import NSDate_TimeAgo

class UserPhoto {

    var url: String = ""
    var timeInMiliSec: Double = Double()
    
    func getUrl() -> String {
        return self.url
    
    }
    
    func timePassed() -> String {
        var date: NSDate  = NSDate.init(timeIntervalSince1970: self.timeInMiliSec) //[[NSDate alloc] initWithTimeIntervalSince1970:0];
        var ago: NSString  = date.timeAgo() //[date timeAgo];
        return ago as String
    }


}
