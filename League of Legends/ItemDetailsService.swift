//
//  ItemDetailsService.swift
//  League of Legends
//
//  Created by Simon De Boeck on 15/01/16.
//  Copyright © 2016 Simon De Boeck. All rights reserved.
//

//
//  ItemService.swift
//  League of Legends
//
//  Created by Simon De Boeck on 26/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

//
//  Service.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import Foundation
class ItemDetailsService{
    
    enum Error: ErrorType
    {
        case MissingJsonProperty(name: String)
        case NetworkError(name: String?)
        case UnexpectedStatusCode(name: Int)
        case MissingData
        case InvalidJsonData
    }
    
    static let sharedService = ItemDetailsService()
    private let url: NSURL
    private let session: NSURLSession
    
    init(){
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        let baseUrl = properties["itemsUrl"] as! String
       
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        
    }
    
    func createFetchtask(completionHandler: Result<[ItemDetail]> -> Void) -> NSURLSessionTask{
        return session.dataTaskWithURL(url){
            data,response, error in
            let completionHandler: Result<[ItemDetail]> -> Void = {
                result in
                dispatch_async(dispatch_get_main_queue()){
                    completionHandler(result)
                }
            }
            
            guard let response = response as? NSHTTPURLResponse else{
                completionHandler(.Failure(.NetworkError(name: error?.description)))
                return
            }
            
            guard response.statusCode == 200 else{
                completionHandler(.Failure(.UnexpectedStatusCode(name: response.statusCode)))
                return
            }
            guard let data = data else {
                completionHandler(.Failure(.MissingData))
                return
            }
            do
            {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options:
                    NSJSONReadingOptions()) as! NSDictionary
                
                let items = json["data"] as! NSDictionary
                var itemArray: [ItemDetail] = []
                for (key,item) in items{
                    try itemArray.append(try ItemDetail(json: item as! NSDictionary))
                }
            
                
                
                completionHandler(.Success(itemArray))
                
                
            } catch let _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
                return
            }
        }
        
        
    }
    
}


