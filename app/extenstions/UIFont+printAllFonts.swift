import Foundation
import UIKit

extension UIFont {
    
    public static func printAllFonts() {
    
        for familyName:String in UIFont.familyNames {
            print("Family Name: \(familyName)")
            for fontName:String in UIFont.fontNames(forFamilyName: familyName) {
                print("--Font Name: \(fontName)")
            }
        }
        
    }
    
}
