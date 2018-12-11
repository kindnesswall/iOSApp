
import UIKit
import MGSwipeTableCell

class ChatListTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var chatTxt: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var unreadMsgCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        UIFunctions.makeCircleView(borderWidth: 1, imageView: self.profileImage, borderColor: UIColor(red:111.0/255.0,green:210.0/255.0,blue:255.0/255.0,alpha:1))
        
        UIFunctions.makeCornerRadius(imageView: self.unreadMsgCount, cornerRadius: 6)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
  
    func setValue(chat:ChatAbs){

        name.text = "somebody"//user?.name
        
        if chat.chat_id == 0{
            name.text = "گروه کلاس"
        }
        
        chatTxt.text = chat.last_message?.text ?? ""
        if chat.count_unseen == 0 || chat.count_unseen == nil {
            unreadMsgCount.hide()
        }else{
            unreadMsgCount.text = UIFunctions.CastNumberToPersian(input: chat.count_unseen!)
        }
        guard let msg = chat.last_message else {
            return
        }
        self.chatTxt.text = msg.text ?? ""
        
        guard let time = msg.time,let currentTime = AppDelegate.me().current_time else {
            return
        }
        self.time.text = DateHandler.getSendingMsgTime(currentDay: currentTime.day_of_week!, sendingTime: time)
        
    }
}
