//
//  ChampionsViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import UIKit

class ChampionsViewController: UICollectionViewController{
    
    var champions: [Champion] = []
    var currentTask: NSURLSessionTask?
    
    override func viewDidLoad() {
        currentTask = Service.sharedService.createFetchtask{
            [unowned self] result in switch result{
            case .Success(let champions):
                self.champions = champions
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
        return champions.count;
    }
    
  
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let champion = champions[indexPath.row]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("championCell",forIndexPath: indexPath) as! MyCollectionViewCell
        cell.layer.borderWidth=1.0
        
        cell.myLabel.text = champion.name
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var imageUrl = properties["imageUrl"] as! String
        imageUrl += champion.image
     
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? StartViewController{
        
        
        } else {
            switch(segue.identifier!){
            case "showDetail":
            let selectedIndexPath = collectionView!.indexPathsForSelectedItems()!.first!
    
            let detailController = (segue.destinationViewController as! UINavigationController).topViewController as! ChampionDetailViewController
            detailController.champion = champions[selectedIndexPath.item]
                break
            case "add":
    
                break
            default:
                fatalError("Unknown Segue")
        }
    }
    }
    
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    @IBAction func goBackToChampionsViewController(segue: UIStoryboardSegue){
        
    }
    
    
    
    
    
    
    
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailController = (segue.destinationViewController as! UINavigationController).topViewController as! ParkingLotViewController
        let parkingLot = parkingLots[tableView.indexPathForSelectedRow!.row]
        detailController.parkingLot = parkingLot
        
    }
    */
}
