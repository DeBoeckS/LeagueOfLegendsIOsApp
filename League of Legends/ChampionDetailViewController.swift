//
//  ChampionDetailViewController.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import UIKit

class ChampionDetailViewController : UIViewController{
    
    @IBOutlet weak var championTitle: UILabel!
    @IBOutlet weak var championImage: UIImageView!
    @IBOutlet weak var championAttack: UILabel!
    @IBOutlet weak var championDefense: UILabel!
    @IBOutlet weak var championMagic: UILabel!
    @IBOutlet weak var championDifficulty: UILabel!
    @IBOutlet weak var championBlurb: UILabel!
    
    var champion: Champion!
    
    override func viewDidLoad() {
        self.title = champion.name
        self.championTitle.text = champion.title
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        var imageUrl = properties["imageUrl"] as! String
        imageUrl += champion.image
        
        if let url = NSURL(string: imageUrl) {
            downloadImage(url,imageView: championImage)
        }
        self.championBlurb.text = champion.blurb
        self.championDefense.text = String(champion.info["defense"] as! Int)
        self.championAttack.text = String(champion.info["attack"] as! Int)
        self.championDifficulty.text = String(champion.info["difficulty"] as! Int)
        self.championMagic.text = String(champion.info["magic"] as! Int)
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let _ = segue.destinationViewController as? ChampionDetailViewController{
            
            
        } else {
              if let _ = segue.destinationViewController as? ChampionsViewController{
                
        
              }else{
                
            switch(segue.identifier!){
            case "showBuild":
                
                
                let buildController = (segue.destinationViewController as! UINavigationController).topViewController as! BuildViewController
                buildController.champBuild = champion.builds
                break
            
            default:
                fatalError("Unknown Segue")
            }
        }
        }
       }
    
    
    @IBAction func goBackToChampionDetail(segue: UIStoryboardSegue){
        
    }
    
    
    
}
