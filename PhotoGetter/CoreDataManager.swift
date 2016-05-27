//
//  CoreDataManager.swift
//  PhotoGetter
//
//  Created by IrynaP on 5/26/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    func saveNewUser(user: InstaUser) {
       let managedContext = appDelegate.managedObjectContext
        
        let newUser = NSEntityDescription.insertNewObjectForEntityForName("InstaUser", inManagedObjectContext: managedContext)
        
        newUser.setValue(user.id, forKey: "id")
        newUser.setValue(user.username, forKey: "username")
        newUser.setValue(user.fullName, forKey: "fullName")
        newUser.setValue(user.profilePicture, forKey: "profilePicture")
        newUser.setValue(user.bio, forKey: "bio")
        newUser.setValue(user.website, forKey: "website")
        
        //try to save the user
        do{
            try managedContext.save()
            print("User is saved!")
            
        }
        catch let error as NSError {
            print(error)
            print("Can't save a user!")
            
        }
    }
    
    func getUserById(userId: String) -> InstaUser {
        //var result = [InstaUser]()
        let managedContext = appDelegate.managedObjectContext
        var user = InstaUser()
        let request = NSFetchRequest(entityName: "InstaUser")
       
        do {
            let result = try managedContext.executeFetchRequest(request) as! [NSManagedObject]
            print(result.count)
            print(String(result.dynamicType))
            
            for current in result {
                if current.valueForKey("id") as! String == userId {
                    user.id = current.valueForKey("id") as! String
                    user.username = current.valueForKey("username") as! String
                    user.fullName = current.valueForKey("fullName") as! String
                    user.bio = current.valueForKey("bio") as! String
                    user.website = current.valueForKey("website") as! String
                    break
                }
            
            }
        }
            
        catch {
            print("Cannot get users!")
            
        }
        return user
    
    }
    
    func updateUser(user: InstaUser) {
        let managedContext = appDelegate.managedObjectContext
        let predicate = NSPredicate(format: "%K == %@", "id", "\(user.id)")
        let fetchRequest = NSFetchRequest(entityName: "InstaUser")
        fetchRequest.predicate = predicate
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            var result = results[0]
            print("Before update \(result.valueForKey("username"))")
            result.setValue(user.username, forKey: "username")
            result.setValue(user.fullName, forKey: "fullName")
            result.setValue(user.bio, forKey: "bio")
            result.setValue(user.website, forKey: "website")
        }
        catch {
            print(error)
        
        }
        
        do {
            try managedContext.save()
            
        } catch {
            print(error)
        }
        
    }
}
