
import Foundation
import SwiftMessages

class FlashMessage {
    
    public static func showMessage(body:String,theme:Theme,seconds:Double?=nil){
        
        var view:MessageView
        var content = body
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad {
            view = MessageView.viewFromNib(layout: .messageView)
        }else{
            view = MessageView.viewFromNib(layout: .cardView)
            for _ in 1..<100 {
                content += " "
            }
        }
        
        view.configureTheme(theme)
        view.button?.hide()
        view.titleLabel?.font=AppConst.Resource.Font.getBoldFont(size: 12)
        view.titleLabel?.textAlignment = .right
        view.bodyLabel?.font=AppConst.Resource.Font.getRegularFont(size: 12)
        view.bodyLabel?.textAlignment = .right
        //rtl
        
        view.configureContent(title: "", body: content)
        
        if let seconds=seconds {
            var config=SwiftMessages.Config()
            config.duration = .seconds(seconds: seconds)
            SwiftMessages.show(config: config, view: view)
        } else {
            SwiftMessages.show(view: view)
        }
    }
    
}

