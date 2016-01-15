//
//  ChampionsViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import UIKit

class BuildViewController: UICollectionViewController{
    
    var champBuild: [Block] = []
    var items: [Item] = []
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad(){
        
        for element in champBuild{
            for item in element.items{
               self.items.append(Item.init(id: item.id, count: item.count))
            }
        }
    }
    
    deinit{
        currentTask?.cancel();
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return champBuild.count;
    }
    
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let item = items[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("itemCell",forIndexPath: indexPath) as! MyCollectionViewCell
        cell.layer.borderWidth=1.0
        
        currentTask = ItemService.init(id:String(item.id)).createFetchtask{
            [unowned self] result in switch result{
            case .Success(let result):
                 cell.myLabel.text = String(item.count) + "x " + result
            case .Failure(let error):
                debugPrint(error)
                
            }
            
        }
        currentTask!.resume()
        
       
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var imageUrl = properties["itemImage"] as! String
        imageUrl += String(item.id)
        imageUrl += ".png"
        
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
        
        
    }
    
   
    
    
    
}
