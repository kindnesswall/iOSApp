
import Foundation
import UIKit

class Message:Codable {
    var message_id:Int?
    var sender_id:Int?
    var text:String?
//    var time:Time?
    var time:String?
    var voice_url:String?
    var message_type:String?
    var profileImageUrl:String?
}
