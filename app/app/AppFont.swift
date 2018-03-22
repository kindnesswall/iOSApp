
import Foundation
import UIKit

class AppFont {
    static func getRegularFont(size:CGFloat)->UIFont {
        return UIFont(name: "IRANSansMobile", size: size)!
    }
    static func getLightFont(size:CGFloat)->UIFont {
        return UIFont(name: "IRANSansMobile-Light", size: size)!
    }
    static func getBoldFont(size:CGFloat)->UIFont {
        return UIFont(name: "IRANSansMobile-Bold", size: size)!
    }
    
    static func getIcomoonFont(size:CGFloat)->UIFont {
        return UIFont(name: "icomoon" , size:size)!
    }
}
