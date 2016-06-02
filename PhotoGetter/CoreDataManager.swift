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
    var hasLocalProfilePhoto: Bool = false
    
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
        let user = InstaUser()
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
                    user.profilePicture = current.valueForKey("profilePicture") as! String
                    print("Getting user")
                    print(user.profilePicture)
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
        print("On update")
        print(user.profilePicture)
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            let result = results[0]
            result.setValue(user.username, forKey: "username")
            result.setValue(user.fullName, forKey: "fullName")
            result.setValue(user.bio, forKey: "bio")
            result.setValue(user.website, forKey: "website")
            result.setValue(user.profilePicture, forKey: "profilePicture")
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
    
    func isSaved(user: InstaUser) -> Bool {
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "InstaUser")
        
        do {
            let result = try managedContext.executeFetchRequest(request) as! [NSManagedObject]
            
            for current in result {
                if current.valueForKey("id") as! String == user.id {
                    return true
                }
            }
        }
            
        catch {
            print("Cannot get users!")
            
        }
        return false        
    }


}
