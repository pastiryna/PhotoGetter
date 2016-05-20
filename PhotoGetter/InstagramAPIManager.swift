//
//  InstagramAPIManager.swift
//  PhotoGetter
//
//  Created by IrynaP on 4/20/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import Foundation
import UIKit

class InstagramAPIManager {
    
    static let apiManager = InstagramAPIManager()
    //let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let CLIENT_ID = "6080917e427b4c6599b0056fc5ce54da"
    let REDIRECT_URI = "http://mysupertestapp.com/"
    let CLIENT_SECRET = "0c490f39cc7143d083bdd5a2b0be33f9"
    
    var accessToken: String = ""
    
    
    func makePostWithCodeForToken(code: String, completion: (accessToken: String, success: Bool) -> Void) -> String {
    
        let post = "client_id=\(CLIENT_ID)&client_secret=\(CLIENT_SECRET)&grant_type=authorization_code&redirect_uri=\(REDIRECT_URI)&code=\(code)"        
        let postData: NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        //let postLength = String(postData.length)
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.instagram.com/oauth/access_token")!)
        request.HTTPBody = postData
        request.HTTPMethod = "POST"
    
    
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler:{ (data, response, error) -> Void in
            print("Response: \(response)")
            
            if (data != nil) {
                let stringData = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print(stringData) }
            print("Error: \(error)")
            
            do {
                let userDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                InstagramAPIManager.apiManager.accessToken = userDict.valueForKey("access_token") as! String
                print("Token in apiMan after request \(InstagramAPIManager.apiManager.accessToken)")
                let accessTok = userDict.valueForKey("access_token") as! String
                self.setUserDefaults(userDict)
                print("Access_token in UserDefaults: \(NSUserDefaults.standardUserDefaults().stringForKey("accessToken"))")
                completion(accessToken: accessTok, success: true)
                
            }
            catch {
            completion(accessToken: "", success: false)
            print("Access_token hasn't come!")
                }
        })
        task.resume()
        return InstagramAPIManager.apiManager.accessToken

    }
    
    
    func getUserInfo(accessToken: String, completion: (userDefaults: NSUserDefaults?, success: Bool) -> Void) {
        var userDict: NSDictionary?
        let url = "https://api.instagram.com/v1/users/self/?access_token=\(accessToken)"
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            print("Status Code \(httpResponse.statusCode)")
            
            if !(self.checkResponse(httpResponse)) {
                completion(userDefaults: nil, success: false)
                return
            }
                
                else{
               
                    do {
                           userDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                           let userData = userDict!.valueForKey("data") as! NSDictionary
                           self.setUserDefaults(userData)
                           completion(userDefaults: NSUserDefaults.standardUserDefaults(), success: true)
                        
                    }
                    catch {
                        completion(userDefaults: nil, success: false)
                        print("No response :(")
                    }
                }
            })
            task.resume()
           }
    
    
    func getUserPhotos(accessToken: String, completion: (photos: [UserPhoto], success: Bool) -> Void) {
        var userPhotos:[UserPhoto] = []
        //var userDict: NSDictionary
        let requestUrl: NSURL = NSURL(string: "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(accessToken)")!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        _ = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            print("Status Code \(httpResponse.statusCode)")
            
            if !(self.checkResponse(httpResponse)) {
                completion(photos: userPhotos, success: false)
                return
            }
            
            else{
            
                do {
                
                    let userDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let userData = userDict.valueForKey("data") as! [NSDictionary]
                    
                    for current: NSDictionary in userData {
                        let photo = UserPhoto()
                        photo.url = current.valueForKey("images")!.valueForKey("low_resolution")!.valueForKey("url") as! String
                        photo.timeInMiliSec = Double(current.valueForKey("created_time") as! String)!
                        userPhotos.append(photo)
                    }
                    
                    
                    //var photoUrls: [String] = [String]()
                    //photoUrls = self.getPhotoUrls(userData)
                    completion(photos: userPhotos, success: true)
                   }
                catch {
                    print("No response :(")
                    completion(photos: userPhotos, success: false)
                }
            }
        }).resume()
    }
    
    
    func checkResponse(response: NSHTTPURLResponse) -> Bool {
        if (response.statusCode != 200) {
//            let alert = UIAlertController()
//            alert.title = "Khalepa!"
//            alert.message = "Response code \(response.statusCode)"
            return false
        }
        else {
        return true
        }
         
    }
    
    func checkUserHasData(accessToken: String) -> Bool {
        return false
    
    }


    
   func getPhotoUrls(userData: [NSDictionary]) -> [String] {
        var photoUrls: [String] = []
        var imagesDict: [NSDictionary]
       
        for i in userData {
            if let image = i["images"] as? NSDictionary {
                photoUrls.append(image.valueForKey("low_resolution")?.valueForKey("url") as! String)
                print("Photo Url \(image.valueForKey("low_resolution")?.valueForKey("url") as! String)")
            }
        
        }
        return photoUrls
    }
    
    func setUserDefaults(userDict: NSDictionary) {
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("access_token"), forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("user")!.valueForKey("id") as! String, forKey: "id")
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("user")!.valueForKey("username") as! String, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("user")!.valueForKey("full_name") as! String, forKey: "fullName")
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("user")!.valueForKey("profile_picture") as! String, forKey: "profilePicture")
        NSUserDefaults.standardUserDefaults().setObject(userDict.valueForKey("bio"), forKey: "bio")
    
    }
    
    func getUserInfoById(userId: String, accessToken: String, completion: (user: InstaUser?, success: Bool) -> Void ) {
        var user = InstaUser()
        let requestUrl: NSURL = NSURL(string: "https://api.instagram.com/v1/users/\(userId)/?access_token=\(accessToken)")!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
           
            if !self.checkResponse(httpResponse) {
                completion(user: nil, success: false)
                return
            
            }
            
            else {
                do {
                    
                    let allResponse = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let userData = allResponse.valueForKey("data") as! NSDictionary
            
                    user.id = userData.valueForKey("id") as! String
                    print("Id \(user.id)")
                    user.username = userData.valueForKey("username") as! String
                    print("Username \(user.username)")
                    user.fullName = userData.valueForKey("full_name") as! String
                    print("FullName \(user.fullName)")
                    user.profilePicture = userData.valueForKey("profile_picture") as! String
                    print("ProfilePicture \(user.profilePicture)")
                    user.bio = userData.valueForKey("bio") as! String
                    print("Bio \(user.bio)")
                    user.website = userData.valueForKey("website") as! String
                    print("Website \(user.website)")
                    user.numberOfPosts = userData.valueForKey("counts")!.valueForKey("media") as! Int
                    print("Number \(user.numberOfPosts)")
                    user.numberFollowing = userData.valueForKey("counts")!.valueForKey("follows") as! Int
                    user.numberOfFollowers = userData.valueForKey("counts")!.valueForKey("followed_by") as! Int
                
                    completion(user: user, success: true)
                }
                    
                catch {
                    print("No response :(")
                    completion(user: nil, success: false)
                }
            }
        }).resume()
            
        
    }
     
    func getUserPhotosById(userId: String, accessToken: String, completion: (photos: [UserPhoto], success: Bool) -> Void) {
        var userPhotos:[UserPhoto] = []
        //var userDict: NSDictionary
        let requestUrl: NSURL = NSURL(string: "https://api.instagram.com/v1/users/\(userId)/media/recent/?access_token=\(accessToken)")!
        let request = NSMutableURLRequest(URL: requestUrl)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        _ = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            let httpResponse = response as! NSHTTPURLResponse
            print("Status Code \(httpResponse.statusCode)")
            
            if !(self.checkResponse(httpResponse)) {
                completion(photos: userPhotos, success: false)
                return
            }
                
            else{
                
                do {
                    
                    let userDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let userData = userDict.valueForKey("data") as! [NSDictionary]
                    
                    for current: NSDictionary in userData {
                        let photo = UserPhoto()
                        photo.url = current.valueForKey("images")!.valueForKey("low_resolution")!.valueForKey("url") as! String
                        photo.timeInMiliSec = Double(current.valueForKey("created_time") as! String)!
                        userPhotos.append(photo)
                    }
                    
                    
                    //var photoUrls: [String] = [String]()
                    //photoUrls = self.getPhotoUrls(userData)
                    completion(photos: userPhotos, success: true)
                }
                catch {
                    print("No response :(")
                    completion(photos: userPhotos, success: false)
                }
            }
        }).resume()
    }
    
    
    func getUserFollowers(accessToken: String, completion: (users: [InstaUser], success: Bool) -> Void) {
        var users: [InstaUser] = []
        let url = "https://api.instagram.com/v1/users/self/followed-by?access_token=\(accessToken)"
        let requestUrl = NSURL(string: url)
        let request = NSMutableURLRequest(URL: requestUrl!)
        request.HTTPMethod = "GET"
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
           
            if !(self.checkResponse(response as! NSHTTPURLResponse)) {
                completion(users: users, success: false)
                print("Error \(error)")
                print("Data \(String(data))")
                return
            }
            
            else {
                do {
                    
                    let usersDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let usersDataArray = usersDict.valueForKey("data") as! [NSDictionary]
                    
                    for current in usersDataArray {
                        var user = InstaUser()
                        user.username = current.valueForKey("username") as! String
                        user.profilePicture = current.valueForKey("profile_picture") as! String
                        user.fullName = current.valueForKey("full_name") as! String
                        user.id = current.valueForKey("id") as! String
                        users.append(user)
                    }
                    
                    completion(users: users, success: true)
                }
                catch {
                    print("No response :(")
                    completion(users: users, success: false)
                }
            
            }
            
        
        
        }).resume()
        
    
    
    }

        
    
    
}
    
    






