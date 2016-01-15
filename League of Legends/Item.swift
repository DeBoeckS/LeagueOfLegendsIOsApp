//
//  Item.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import Foundation

class Item{
    
    let id: Int
    let count: Int
    var name: String
   
    
    init(id: Int, count: Int){
        self.id = id
        self.count = count
        self.name = "temp"
       
    }
    
   
    
}

extension Item{
    convenience init(json: NSDictionary) throws  {
        guard let id = json["id"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "id")
        }
        guard let count = json["count"] as? Int else{
            throw Service.Error.MissingJsonProperty(name: "count")
        }
        
        
        
        self.init(id: id, count: count)
        
        
    }
}