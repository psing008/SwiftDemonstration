
import Foundation

/**
 * Model class for FeedItems.
 *
 * We need to save and serialize this data for caching, we could have made this a 'Class'
   and use NSCoding, but then it would not be a value type anymore. To enforce value type, we extend this struct
   to make it NSCoding compliant with a Coding class, and handle serialization.
    Core Data would have been a overkill for this project, as we are not handling complex object graphs
 */


public struct FeedItemModel {
    //Each event may or may not have an image, or schedule info associated with it, hence optional, rest are not
   public internal(set) var id:Int
   public internal(set) var itemDescription:String
   public internal(set) var title:String
   public internal(set) var imageURL:String?
   public internal(set) var date:String?
   public internal(set) var time:String?
   public internal(set) var locationLine1:String?
   public internal(set) var lcoationLine2:String?
    
    
    public init(id:Int,itemDescription:String,title:String,imageURL:String?,date:String?,time:String?,locationLine1:String?,lcoationLine2:String?){
    
            self.id = id
            self.itemDescription = itemDescription
            self.title = title
            self.imageURL = imageURL
            self.date = date
            self.time = time
            self.locationLine1 = locationLine1
            self.lcoationLine2 = lcoationLine2
        }
    
    // Helper method to return array of FeedItemModels from json
    static func listItemsFromJSON(json:JSONArray) ->[FeedItemModel] {
        return json.flatMap({ (feedItem:Dictionary) -> FeedItemModel? in
            
            let id = feedItem["id"] as! Int
            let itemDescription = feedItem["description"] as! String
            let title = feedItem["title"] as! String
            let imageURL = feedItem["image"] as? String
            let dateString = feedItem["date"] as? String
            let date = Utility.returnLocalDate(dateString: dateString,withFormat:"MMM d, yyyy")
            let time = Utility.returnLocalDate(dateString: dateString, withFormat: "h:mm a")
            let locationLine1 = feedItem["locationline1"] as? String
            let locationLine2 = feedItem["locationline2"] as? String
            
            return FeedItemModel(id: id, itemDescription: itemDescription, title: title, imageURL: imageURL, date: date,time:time, locationLine1: locationLine1, lcoationLine2: locationLine2)
        })
    }
}
    extension FeedItemModel {
        // This class wraps our struct model into Coding Class which is able to use NSCoding to be in use with NSKeyedArchiver
        class Coding: NSObject,NSCoding {
            
            let feedItem:FeedItemModel?
            init(feedModelStruct:FeedItemModel){
                self.feedItem = feedModelStruct
                super.init()
            }
            
            // Required by NSCoding
            required init?(coder aDecoder: NSCoder) {
                guard let id = aDecoder.decodeInteger(forKey: "id") as? Int,
                      let itemDescription = aDecoder.decodeObject(forKey: "itemDescription") as? String,
                      let title = aDecoder.decodeObject(forKey: "title") as? String,
                      let imageURL =  aDecoder.decodeObject(forKey: "imageURL") as? String?,
                      let date = aDecoder.decodeObject(forKey: "date") as? String?,
                      let time = aDecoder.decodeObject(forKey: "time") as? String?,
                      let locationLine1 = aDecoder.decodeObject(forKey: "locationLine1") as? String?,
                      let lcoationLine2 = aDecoder.decodeObject(forKey: "lcoationLine2") as? String?
                    else{
                        return nil
                }
                
                feedItem = FeedItemModel(id: id, itemDescription: itemDescription, title: title, imageURL: imageURL, date: date, time: time, locationLine1: locationLine1, lcoationLine2: lcoationLine2)
                super.init()
            }
            // Required by NSCoding
           public func encode(with aCoder: NSCoder) {
                guard let itemFeedModel = feedItem else {
                    return
                }
                aCoder.encode(itemFeedModel.id, forKey: "id")
                aCoder.encode(itemFeedModel.itemDescription, forKey: "itemDescription")
                aCoder.encode(itemFeedModel.title, forKey: "title")
                aCoder.encode(itemFeedModel.imageURL, forKey: "imageURL")
                aCoder.encode(itemFeedModel.date, forKey: "date")
                aCoder.encode(itemFeedModel.time, forKey: "time")
                aCoder.encode(itemFeedModel.locationLine1, forKey: "locationLine1")
                aCoder.encode(itemFeedModel.lcoationLine2, forKey: "lcoationLine2")
            }
        }
    }

    // Protocols implementations. For encoded we return class objects which follow NSCoding protocol
    extension FeedItemModel: Encodable {
        var encoded: Decodable? {
            return FeedItemModel.Coding(feedModelStruct: self)
        }
    }


    // Our initWithCoder, which we implemented in our class, will return our Model objects here
    extension FeedItemModel.Coding: Decodable {
        var decoded: Encodable? {
            return self.feedItem
        }
    }







