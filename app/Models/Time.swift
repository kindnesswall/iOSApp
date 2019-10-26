import Foundation
import UIKit

class Time {
    
    var en_date:String?
    var fa_date:String?
    var day_of_week:String?
    
    var is_Active:Bool=false
    var is_Today:Bool=false
    
    init(en_date:String?,fa_date:String?,day_of_week:String?){
        self.en_date = en_date
        self.fa_date = fa_date
        self.day_of_week = day_of_week
    }
    
    init(json:[String:String]?){
        
        if let json=json {
            
        self.en_date=json["en_time"]
        self.fa_date=json["fa_time"]
        self.day_of_week=json["day_of_weeak"]
        }
    }
    
    init(time_json:[String:Any]){
        self.en_date = time_json["en_time"] as? String
        self.fa_date = time_json["fa_time"] as? String
        self.day_of_week = time_json["day_of_week"] as? String

    }
    init(date_json:[String:Any]){
        self.en_date = date_json["en_date"] as? String
        self.fa_date = date_json["fa_date"] as? String
        self.day_of_week = date_json["day_of_week"] as? String
        
    }
}
