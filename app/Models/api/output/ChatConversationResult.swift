
import Foundation

class ChatConversationOutput: Codable {
    
    var status:Int?
    var result:ChatConversationResult?
    
}

class ChatConversationResult: Codable {
    
//    var last_seen_time:Time?
    var lastSeenTime:String?
    var totalCount:Int?
    var list:[Message]?
    
}

