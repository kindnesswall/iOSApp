
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
        view.button?.isHidden=true
        view.titleLabel?.font=AppFont.getBoldFont(size: 12)
        view.titleLabel?.textAlignment = .right
        view.bodyLabel?.font=AppFont.getRegularFont(size: 12)
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
//    public static func showNotification(body:String){
//        var view:MessageView
//        let content = body
//        view = MessageView.viewFromNib(layout: .messageViewIOS8)
//
//        view.configureTheme(.info)
//
//        view.titleLabel?.font=AppFont.getBoldFont(size: 12)
//        view.titleLabel?.textAlignment = .right
//        view.bodyLabel?.font=AppFont.getRegularFont(size: 12)
//        view.bodyLabel?.textAlignment = .right
//        //rtl
//        view.configureContent(title: "", body: content)
//
//        var config = SwiftMessages.Config()
//        config.duration = .seconds(seconds: 12)
//
//        SwiftMessages.show(config: config, view: view)
//    }
    
}

