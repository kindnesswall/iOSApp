
import Foundation
import UIKit

public class NibLoader {
    public static func loadViewFromNib(name:String,owner:Any,nibType:AnyClass) -> UIView {
        let bundle = Bundle(for: nibType)
        let nib = UINib(nibName: name, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: owner, options: nil)[0] as! UIView
        return view
    }
    
    public static func loadAndInitView(name:String,owner:Any,nibType:AnyClass,superView:UIView)->UIView{
        
        let width=superView.bounds.width
        let height=superView.bounds.height
        
        let view=NibLoader.loadViewFromNib(name: name, owner: owner, nibType: nibType)
        
        view.frame=CGRect(x: 0, y: 0, width: width, height: height)
        
        superView.addSubview(view)
        
        return view

    }
}
