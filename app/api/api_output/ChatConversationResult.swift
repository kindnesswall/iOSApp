
import Foundation

class ChatConversationOutput: Codable {
    
    var status:Int?
    var result:ChatConversationResult?
    
}

class ChatConversationResult: Codable {
    
//    var last_seen_time:Time?
    var last_seen_time:String?
    var total_count:Int?
    var list:[Message]?
    
}

