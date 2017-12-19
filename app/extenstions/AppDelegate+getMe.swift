import UIKit

extension AppDelegate {
    
    static func me()->AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
}
