//
//  ChampionsViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import UIKit
import CoreData

class UserBuildCollectionViewController: UICollectionViewController{
    
   
    var items: [ItemDetail] = []
    var selecteditems: [NSManagedObject] = []
    var selectedIndexes: [Int] = []
    var currentTask: NSURLSessionTask?
    

    
    override func viewDidLoad(){
        currentTask = ItemDetailsService.sharedService.createFetchtask{
            [unowned self] result in switch result{
            case .Success(let result):
                self.items = result
                self.collectionView!.reloadData()
            case .Failure(let error):
                debugPrint(error)
            }
            
        }
        currentTask!.resume();
        
        
    }
    
    deinit{
        currentTask?.cancel();
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        
        
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count;
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell",forIndexPath: indexPath) as! MyCollectionViewCell
        cell.layer.borderWidth=1.0
        cell.myLabel.text = item.name
        
        cell.backgroundColor = UIColor.whiteColor()
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var imageUrl = properties["itemImage"] as! String
        imageUrl += item.full
        
        if let url = NSURL(string: imageUrl) {
            downloadImage(url,imageView: cell.myImage)
        }

        
        return cell
    }

    /*Source: http://stackoverflow.com/questions/24231680/loading-image-from-url 
   */
    
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
        var cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        
        if(cell?.backgroundColor == UIColor.orangeColor()){
           
            cell?.backgroundColor = UIColor.whiteColor()
            var counter: Int = 0
            for item in selecteditems{
                if(item.valueForKey("name") as! String == items[indexPath.item].name){
                    selecteditems.removeAtIndex( counter                    )
                }
                counter++
            }
            updateItemsSelected()
            

        }else{
            
            if(selecteditems.count < 6){
                cell?.backgroundColor = UIColor.orangeColor()
                
                let selected = items[indexPath.item]
                
                let appDelegate =
                UIApplication.sharedApplication().delegate as! AppDelegate
                
                let managedContext = appDelegate.managedObjectContext
                
                
                let entity =  NSEntityDescription.entityForName("ItemDetail",
                    inManagedObjectContext:managedContext)
                
                let item = NSManagedObject(entity: entity!,
                    insertIntoManagedObjectContext: managedContext)
                
               
                
                item.setValue(selected.name, forKey: "name")
                item.setValue(selected.id, forKey: "id")
                item.setValue(selected.full, forKey: "full")
                item.setValue(selected.desc, forKey: "desc")
                
                
                
                do {
                    try managedContext.save()
                    selecteditems.append(item)
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
                
                updateItemsSelected()
            }else{
                self.title = "You can only select 6 items"
            }
 
        }
        
    }
    
    func updateItemsSelected() {
        self.title = "\(selecteditems.count) items selected"
    }
    
 }
    
    
    
    


