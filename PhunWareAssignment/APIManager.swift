//
//  APIManager.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/4/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit
// shortcuts for long type names
typealias JSON = Any
typealias JSONDictionary = Dictionary<String, JSON>
typealias JSONArray = Array<JSONDictionary>

//HTTP Error Codes
enum HTTPError:Error {
    case InvalidURL
    case HTTPError(Error)
    case InvalidJSON
    case NoData
    case CorruptImageData
    case Unknown
}

// With this enum we can handle returning results to any objects
enum Results<T> {
    case Success(T)
    case Failure(HTTPError)
    
    var associatedValue:Any {
        get{
            switch self {
            case .Success(let value): return value
            case .Failure(let value): return value
                
            }
        }
    }
}


//Singleton class for Networking
class APIManager {
    static let sharedInstance = APIManager()
    let urlSession:URLSession!
    let urlConfig:URLSessionConfiguration!
    
    private init(){
        self.urlConfig = URLSessionConfiguration.default
        let headers:[String:String] = [
            "Accept":"application/json",
            "Content-Type":"application/json"
        ]
        self.urlConfig.httpAdditionalHeaders = headers
        self.urlSession = URLSession(configuration: urlConfig)
    }
    
    func getDataWithPath(urlPath:String,completionBlock:@escaping (Results<Any>) -> Void) {
        
        //If we have cached data, use completionBlock to return that data
        if let dataModels = CacheHandler.sharedInstance.retrieveData() {
            return completionBlock(Results.Success(dataModels))
        }
        
        guard let url = URL(string:urlPath) else {
            return completionBlock(Results.Failure(HTTPError.InvalidURL))
        }

        var urlRequest = URLRequest(url:url)
        urlRequest.timeoutInterval = 4
        
        let task = self.urlSession.dataTask(with: urlRequest) { (data, reponse, error) in
            if let error = error {
                return completionBlock(Results.Failure(HTTPError.HTTPError(error)))
            }
            
            guard let jsonData = data else {
                return completionBlock(Results.Failure(HTTPError.NoData))
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as? JSONArray else {
                return completionBlock(Results.Failure(HTTPError.InvalidJSON))
            }
            
            //Create data models from json, to be returned to view controller
            let dataModels = FeedItemModel.listItemsFromJSON(json: json!)
        
            // Save the data in disk cache
            CacheHandler.sharedInstance.save(data:dataModels)
            
            //return data to view controller, or interactor object
            completionBlock(Results.Success(dataModels))
          
            
        }
        task.resume()
        

    }
    
}
