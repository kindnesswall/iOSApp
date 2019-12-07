import Foundation
import UIKit

class Time {
    
    var enDate:String?
    var faDate:String?
    var dayOfWeek:String?
    
    var isActive:Bool=false
    var isToday:Bool=false
    
    init(enDate:String?,faDate:String?,dayOfWeek:String?){
        self.enDate = enDate
        self.faDate = faDate
        self.dayOfWeek = dayOfWeek
    }
    
    init(json:[String:String]?){
        
        if let json=json {
            
        self.enDate=json["en_time"]
        self.faDate=json["fa_time"]
        self.dayOfWeek=json["day_of_weeak"]
        }
    }
    
    init(timeJson:[String:Any]){
        self.enDate = timeJson["en_time"] as? String
        self.faDate = timeJson["fa_time"] as? String
        self.dayOfWeek = timeJson["day_of_week"] as? String

    }
    init(dateJson:[String:Any]){
        self.enDate = dateJson["en_date"] as? String
        self.faDate = dateJson["fa_date"] as? String
        self.dayOfWeek = dateJson["day_of_week"] as? String
        
    }
}
