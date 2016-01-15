//
//  ItemDetail.swift
//  League of Legends
//
//  Created by Simon De Boeck on 15/01/16.
//  Copyright © 2016 Simon De Boeck. All rights reserved.
//

import Foundation

class ItemDetail{
    
    let id: Int
    let name: String
    let full: String
    
    let desc: String
  
    
    
    
    
    
    init(id: Int, name: String, full: String,desc: String){
        self.id = id
        self.name = name
        self.full = full
        
        self.desc = desc
        
        
        
    }
    
    
}



extension ItemDetail{
    convenience init(json: NSDictionary) throws  {
        guard let id = json["id"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "id")
        }
        guard let name = json["name"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "name")
        }
        guard let description = json["description"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "description")
        }
        
        
        guard let full = json["image"]!["full"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "full")
        }
        
       
        
        self.init(id: id, name: name,full: full, desc: description)
        
        
    }
}