//
//  Service.swift
//  League of Legends
//
//  Created by Simon De Boeck on 25/11/15.
//  Copyright © 2015 Simon De Boeck. All rights reserved.
//

import Foundation
class Service{
    
    enum Error: ErrorType
    {
        case MissingJsonProperty(name: String)
        case NetworkError(name: String?)
        case UnexpectedStatusCode(name: Int)
        case MissingData
        case InvalidJsonData
    }
    
    static let sharedService = Service()
    
    private let url: NSURL
    private let session: NSURLSession
    
    init(){
        let propertiesPath = NSBundle.mainBundle().pathForResource("Properties", ofType: "plist")!
        let properties = NSDictionary(contentsOfFile: propertiesPath)!
        let baseUrl = properties["baseUrl"] as! String
        url = NSURL(string: baseUrl)!
        session = NSURLSession(configuration: NSURLSessionConfiguration.ephemeralSessionConfiguration())
        
        
    }
    
    func createFetchtask(completionHandler: Result<[Champion]> -> Void) -> NSURLSessionTask{
        return session.dataTaskWithURL(url){
            data,response, error in
            let completionHandler: Result<[Champion]> -> Void = {
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
            
                let champions = json["data"] as! NSDictionary
                
                var champArray : [Champion] = []
                for key in (champions.allKeys as! [String]).sort(){
                    let champ = champions[key] as! NSDictionary
                try champArray.append(try Champion(json: champ))
                }
                
                
                completionHandler(.Success(champArray))


            } catch let _ as NSError{
                completionHandler(.Failure(.InvalidJsonData))
                return
            } catch let error as Error{
                completionHandler(.Failure(error))
                return
            }
        }
        
        
    }
    
}
