//
//  CacheHandler.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/9/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit

// Singleton class to handle caching

class CacheHandler:NSObject {
    
    static let sharedInstance = CacheHandler()
    
    // File path for disk cache
    var filePath:String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first! as URL
        return url.appendingPathComponent("feedItemsCacheList").path
    }
    
    
    private override init() {}
    
    // Archive data to disk
    func save(data:[FeedItemModel]) {
        let save = NSKeyedArchiver.archiveRootObject(data.encoded, toFile: filePath)
        if save == false {
             print("error caching models")
        }
        
    }
    
    //Unarchive data from disk
    func retrieveData() -> [Any]? {
        if let array = (NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [FeedItemModel.Coding])?.decoded {
            return array
        }
        return nil
    }
}
