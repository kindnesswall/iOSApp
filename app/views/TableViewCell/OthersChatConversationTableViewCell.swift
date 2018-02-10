
import UIKit
import SDWebImage
import UICircularProgressRing

class OthersChatConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLblWidth: NSLayoutConstraint!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var messageDate: UILabel!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var circleProgressRing: UICircularProgressRingView!
    
    @IBOutlet weak var downloadBtn: ButtonWithData!
    
    @IBOutlet weak var playPauseBtn: ButtonWithData!
    
//    @IBOutlet weak var pauseBtn: ButtonWithData!
    
    @IBAction func downloadPlayPauseBtnPressed(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        UIFunctions.makeCircleView(borderWidth: 3, imageView: profileImage)
        
        UIFunctions.setBordersStyle(view: self.messageView, radius: 10, width: 1, color: AppColor.greyBgColor)
        
        circleProgressRing.shouldShowValueText = false
        self.circleProgressRing.isHidden = true
    }
    
    func fillUI(msg:Message) {
        
        if let txt = msg.text {
            
            if txt.width(withConstraintedHeight: CGFloat(10), font: self.messageLabel.font) > AppDelegate.screenWidth {
                
                messageLblWidth.constant = AppDelegate.screenWidth - 120
                
            }else{
                messageLblWidth.constant = txt.width(withConstraintedHeight: CGFloat(10), font: self.messageLabel.font)
            }
            
            self.messageLabel.text = txt
            
        }else{
            messageLblWidth.constant = 29
            messageLabel.text = ""
        }
        
//        if let id = msg.sender_id, let user = AppDelegate.me().users[id] {
//            self.usernameLabel.text = user.name
//        }
        
//        if let url = msg.profileImageUrl {
//            self.profileImage.sd_setImage(with: URL(string: url))
//        }
        
        if let time  = msg.time  {
            self.messageDate.text = UIFunctions.CastNumberToPersian(input: time)
        }
        
//        guard let type = msg.message_type else{
//            return
//        }
//
//        switch type {
//
//        case "text":
            downloadBtn.isHidden = true
            messageLabel.isHidden = false
            playPauseBtn.isHidden = true
            
//            break
//        default:
//            return
//            
//        }
        
    }
}
