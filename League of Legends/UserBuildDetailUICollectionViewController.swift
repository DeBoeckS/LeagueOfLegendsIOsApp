//
//  UserBuildDetailUICollectionViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 15/01/16.
//  Copyright © 2016 Simon De Boeck. All rights reserved.
//

import Foundation

//
//  ChampionsViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import UIKit
import CoreData

class UserBuildDetailUICollectionViewController: UICollectionViewController{
    
    var userBuild: NSManagedObject!
    var itemDetails: [NSManagedObject] = []
    
    override func viewWillAppear(animated: Bool) {
        let items = userBuild.valueForKey("items") as! NSMutableSet
        
        for item in items{
            itemDetails.append(item as! NSManagedObject)
        }
    }
    
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (userBuild.valueForKey("items")?.count)!
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = itemDetails[indexPath.item]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell",forIndexPath: indexPath) as! MyCollectionViewCell
        cell.layer.borderWidth=1.0
        self.title = userBuild.valueForKey("name") as! String?
        
        cell.myLabel.text = item.valueForKey("name") as! String?
     
        
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var imageUrl = properties["itemImage"] as! String
        imageUrl += (item.valueForKey("full") as! String?)!
        
        
        if let url = NSURL(string: imageUrl) {
            downloadImage(url,imageView: cell.myImage)
        }

        
        return cell
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL, imageView: UIImageView){
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    
    
    
    
}
