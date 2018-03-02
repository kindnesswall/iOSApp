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
    
    public static func setBackBtn(navigationItem:UINavigationItem,target:AnyObject,action:Selector?){
        
        let backBtn=UIBarButtonItem()
        
        
        backBtn.target=target
        backBtn.action=action
        
        backBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "icomoon", size: 25)!,NSAttributedStringKey.foregroundColor: UIColor.white], for: UIControlState())
        backBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont(name: "icomoon", size: 25)!,NSAttributedStringKey.foregroundColor: UIColor.white], for: .highlighted)
        
        //        titleBackBtn.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "IranSans-Light", size: 15)!,NSForegroundColorAttributeName: UIColor.white], for: UIControlState())
        
        
        let arrowText="\u{e946}"
        backBtn.title=arrowText
        
        //        titleBackBtn.title=backText
        
        navigationItem.rightBarButtonItems=[backBtn]
        
    }
    
    public static func setLeftBtn(navigationItem:UINavigationItem,target:AnyObject,action:Selector?,text:String,font:UIFont=AppFont.getBoldFont(size: 14)){
        
        let btn=NavigationBarStyle.getNavigationItem(target: target, action: action, text: text,font:font)
        
        navigationItem.leftBarButtonItems=[btn]
        
    }
    
    public static func setRightBtn(navigationItem:UINavigationItem,target:AnyObject,action:Selector?,text:String,font:UIFont=AppFont.getBoldFont(size: 14)){
        
        let btn=NavigationBarStyle.getNavigationItem(target: target, action: action, text: text,font:font)
        
        navigationItem.rightBarButtonItems=[btn]
        
    }
    
    public static func getNavigationItem(target:AnyObject,action:Selector?,text:String,font:UIFont=AppFont.getBoldFont(size: 14))->UIBarButtonItem{
        
        let btn=UIBarButtonItem()
        
        
        btn.target=target
        btn.action=action
        
        btn.setTitleTextAttributes([NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor: AppColor.tintColor], for: UIControlState())
        btn.setTitleTextAttributes([NSAttributedStringKey.font : font,NSAttributedStringKey.foregroundColor: AppColor.tintColor], for: .highlighted)
        
        
        btn.title=text
        
        return btn
        
    }
    public static func removeDefaultBackBtn(navigationItem:UINavigationItem){
        
        let backBtn=UIBarButtonItem()
        
        backBtn.title=""
        
        navigationItem.leftBarButtonItems=[backBtn]
        //        self.navigationItem.hidesBackButton=true
        
    }
    
}

