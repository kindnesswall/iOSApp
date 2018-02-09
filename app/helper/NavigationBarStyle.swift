import Foundation
import UIKit

class NavigationBarStyle {
    
    
    //MARK: - Text,Font
    
    public static func setDefaultStyle(navigationC:UINavigationController?) {
//        navigationC?.navigationBar.barTintColor=AppColor.tintColor
        navigationC?.navigationBar.tintColor=AppColor.tintColor
        navigationC?.navigationBar.titleTextAttributes = [ NSAttributedStringKey.font: AppFont.getBoldFont(size: 17),NSAttributedStringKey.foregroundColor: AppColor.tintColor]
    }
    
    
    //MARK: - Color
    
    public static func setTransparent(navigationC:UINavigationController?) {
        
        setDefaultStyle(navigationC: navigationC)
        
        navigationC?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationC?.navigationBar.shadowImage = UIImage()
        navigationC?.navigationBar.isTranslucent = true
        
    }
    
    public static func setTintColoredWithoutBorder(navigationC:UINavigationController?) {
        
        setDefaultStyle(navigationC: navigationC)
        
        setTransparent(navigationC: navigationC)
        navigationC?.navigationBar.tintColor=AppColor.tintColor
        navigationC?.navigationBar.isTranslucent = false
        
    }
    
    public static func setImageTo(navigationC:UINavigationController?,image:String){
        
        setDefaultStyle(navigationC: navigationC)
        
        let backgroundImage = UIImage(named: image)?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 0, 0, 0), resizingMode: UIImageResizingMode.stretch)
        
        navigationC?.navigationBar.setBackgroundImage(backgroundImage!, for: UIBarMetrics.default)
        navigationC?.navigationBar.shadowImage = UIImage()
        navigationC?.navigationBar.isTranslucent = true
        
    }
    
    
    //MARK: - Back Btn
    
    public static func setBackBtn(navigationItem:UINavigationItem,selfInstance:AnyObject,backBtnClickedFunction:Selector?,backText:String){
        
        let backBtn=UIBarButtonItem()
        
        
        backBtn.target=selfInstance
        backBtn.action=backBtnClickedFunction
        
        backBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "icomoon", size: 25)!,NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState())
        
        //        titleBackBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "IranSans-Light", size: 15)!,NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
        
        
        let arrowText="\u{e946}"
        backBtn.title=arrowText
        
        //        titleBackBtn.title=backText
        
        navigationItem.rightBarButtonItems=[backBtn]
        
    }
    
    public static func setDoneBtn(navigationItem:UINavigationItem,selfInstance:AnyObject,doneBtnClickedFunction:Selector?,doneText:String){
        
        let doneBtn=UIBarButtonItem()
        
        
        doneBtn.target=selfInstance
        doneBtn.action=doneBtnClickedFunction
        
        doneBtn.setTitleTextAttributes([NSAttributedStringKey.font : AppFont.getBoldFont(size: 12),NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState())
        doneBtn.setTitleTextAttributes([NSAttributedStringKey.font : AppFont.getBoldFont(size: 12),NSAttributedStringKey.foregroundColor: UIColor.white], for: .highlighted)
        
        
        doneBtn.title=doneText
        
        navigationItem.leftBarButtonItems=[doneBtn]
        
    }
    public static func removeDefaultBackBtn(navigationItem:UINavigationItem){
        
        let backBtn=UIBarButtonItem()
        
        backBtn.title=""
        
        navigationItem.leftBarButtonItems=[backBtn]
        //        self.navigationItem.hidesBackButton=true
        
    }
    
}

