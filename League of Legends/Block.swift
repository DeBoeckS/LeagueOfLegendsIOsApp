//
//  Block.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import Foundation



class Block{
    let type: String
    let recmath: Bool
    var items: [Item]

    init(type: String, recmath: Bool, items: NSArray){
        self.type = type
        self.recmath = recmath
        self.items = []
        for item in items{
            do{
                try self.items.append(try Item(json: item as! NSDictionary))
            
        }catch let _ as NSError{
            
            return
        }
        
    }
    }
}
    

    

extension Block{
    convenience init(json: NSDictionary) throws  {
        guard let type = json["type"] as? String else{
            throw Service.Error.MissingJsonProperty(name: "type")
        }
        guard let recmath = json["recMath"] as? Bool else{
            throw Service.Error.MissingJsonProperty(name: "recmath")
        }
        guard let items = json["items"] as? NSArray else{
            throw Service.Error.MissingJsonProperty(name: "items")
        }
        
        
        self.init(type: type, recmath: recmath, items: items)
        
        
    }
}