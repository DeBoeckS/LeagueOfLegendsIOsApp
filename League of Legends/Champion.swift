//
//  Champion.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//
import Foundation
class Champion{
    let id: Int
    let title: String
    let name: String
    let image: String
    let info: NSDictionary
    var builds: [Block]
    let key: String
    let blurb: String
   
    
   
    
    
    init(id: Int, title: String, name: String,key: String, image: String, info: NSDictionary,recommended: NSArray, blurb: String){
        self.id = id
        self.title = title
        self.name = name
        self.image = image
        self.key = key
        self.info = info
        self.blurb = blurb
        self.builds = []
        var filteredArray : [NSDictionary] = []
        for (element) in recommended{
            if(element["map"] as! String == "SR" && element["mode"] as! String == "CLASSIC"){
                filteredArray.append(element as! NSDictionary)
            }
        }
        let filteredBlocks = filteredArray[0]["blocks"] as! NSArray
        for (index, element) in filteredBlocks.enumerate() {
            do{
                try builds.append(try Block(json: element as! NSDictionary))
            }
            
            
         catch let _ as NSError{
            
            return
        }
            
        
        }

    
    }
    
    
}



extension Champion{
    convenience init(json: NSDictionary) throws  {
        guard let id = json["id"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "id")
        }
        guard let name = json["name"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "name")
        }
        guard let blurb = json["blurb"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "blurb")
        }
        guard let title = json["title"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "title")
        }
        
        guard let key = json["key"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "key")
        }
        guard let info = json["info"] as? NSDictionary else{
            throw Service.Error.MissingJsonProperty(name: "info")
        }
        guard let recommended = json["recommended"]! as? NSArray
            else{
            throw Service.Error.MissingJsonProperty(name: "recommended")
        }
        
        guard let image = json["image"]!["full"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "image")
        }
        
        self.init(id: id, title: title, name: name,key: key,image: image,info: info,recommended: recommended,blurb: blurb)
        
        
}
}


   