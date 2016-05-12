//
//  PhotoTable.swift
//  PhotoGetter
//
//  Created by IrynaP on 4/26/16.
//  Copyright © 2016 IrynaP. All rights reserved.
//

import UIKit
import MBProgressHUD

class PhotoTable: UITableViewController {
    let user_id = "3152442007"
    var photoUrls: [String] = []
    let acc_tok = "3152442007.6080917.b6d6d78fd7d943b8bd86ca07258a5336"
    var loaded = false
    //var spinner: UIView = UIView()
    
    let mario = "http://www.imagenspng.com.br/wp-content/uploads/2015/02/small-super-mario.png"
    
    var userPhotos: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        InstagramAPIManager.apiManager.getUserPhotos(acc_tok) { (photos, success) -> Void in
            if (success) {
                self.photoUrls = []
                self.tableView.reloadData()
                self.loaded = true
            }
            else {
                self.photoUrls = [String]()
                self.tableView.reloadData()
             
            }
            //self.hideLoader()
        }
        if loaded{
            print("PhotoUrls in Table Method \(photoUrls)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
//        self.view.addSubview(spinner)
//        self.spinner.userInteractionEnabled = false
         self.showLoader()
    }


    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of photo Urls \(photoUrls.count)")
        if photoUrls.count == 0 {
        return 5}
        else {
        return photoUrls.count
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell", forIndexPath: indexPath) as! PhotoCell
        
        if CacheManager.sharedInstance.objectForKey(mario) != nil {
            cell.photo.image = CacheManager.sharedInstance.objectForKey(mario) as! UIImage
            print("Cashed Image for row \(indexPath.row)")
            self.hideLoader()
            return cell
        }
        else {
       
            do {
               try loadImage(mario, completion: { (image, loaded) -> Void in
                    if loaded {
                        cell.photo.image = image
                        print("Still loads not cashed image for row \(indexPath.row)")
                    }
                    })        
                return cell
            }
            catch {
                let current = UIImage(named: "defaultImage")!
                cell.photo.image = current
                return cell
            }
        }
        
    }
    
    
    func loadPhotoByURL(url: String) throws ->  UIImage? {
        let nsUrl = NSURL(string: url)

        if let data = NSData(contentsOfURL: nsUrl!) {
            return UIImage(data: data)
        }
        
        else {
            return UIImage(named: "defaultImage")
        }
       
       
    }
    
    //Used in case loading Instagram photos is impossible
    func loadDefaultTable() {
    }
    
    
    func showLoader() {
        let loader = MBProgressHUD.showHUDAddedTo(self.tableView, animated: true)
        loader.labelText = "Loading..."
        
    }
    
    
    func hideLoader() {
        MBProgressHUD.hideAllHUDsForView(self.tableView, animated: true)
    }
    
    
    func loadImage(urlString: String, completion: (image: UIImage, loaded: Bool) -> Void) {
            let imgURL: NSURL = NSURL(string: urlString)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            let session = NSURLSession.sharedSession()
            _ = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data!)
                    CacheManager.sharedInstance.setObject(image!, forKey: urlString)
                    completion(image: image!, loaded: true)
                }
                else {
                    completion(image: UIImage(), loaded: false)
                }
            }).resume()
    }
    

}
