//
//  UserBuild.swift
//  League of Legends
//
//  Created by Simon De Boeck on 15/01/16.
//  Copyright © 2016 Simon De Boeck. All rights reserved.
//

import Foundation


class UserBuild{
    
     var name : String
     var items: [ItemDetail]
    
    init(name: String, items: [ItemDetail]){
        self.name = name
        self.items = items
    }
    
    
}