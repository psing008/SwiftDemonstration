//
//  Utility.swift
//  PhunWareAssignment
//
//  Created by Piyush Singh on 5/4/17.
//  Copyright © 2017 Piyush Singh. All rights reserved.
//

import UIKit

struct Constants {
    static let FeedItemsURLString = "https://raw.githubusercontent.com/phunware/dev-interview-homework/master/feed.json"
}

struct Utility {
    
    static func returnLocalDate(dateString:String?,withFormat:String) -> String? {
        // convert GMT time string to GMT Formatted Date Object
        guard let gmtDate = self.getGMTDateFromString(dateString: dateString) else {return nil}
        // Convert to local time with user's time zone
        let localFormatter = DateFormatter()
        localFormatter.timeZone = TimeZone.current
        localFormatter.dateFormat = withFormat
        let localTimeString = localFormatter.string(from: gmtDate)
        return localTimeString
    }
    
   static func getGMTDateFromString(dateString:String?) -> Date? {
    guard let dateString = dateString else {
        return nil
    }
        let gmtFormat = DateFormatter ()
        gmtFormat.timeZone = TimeZone(abbreviation: "GMT")
        gmtFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        let gmtDate:Date = gmtFormat.date(from: dateString)!
        return gmtDate
    }
        
}
