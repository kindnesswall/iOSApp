
import Foundation
import UIKit

public class NibLoader {
    public static func loadViewFromNib(name:String,selfInstance:Any,nibType:AnyClass) -> UIView {
        let bundle = Bundle(for: nibType)
        let nib = UINib(nibName: name, bundle: bundle)
        
        // Assumes UIView is top level and only object in CustomView.xib file
        let view = nib.instantiate(withOwner: selfInstance, options: nil)[0] as! UIView
        return view
    }
    
    public static func loadAndInitView(name:String,selfInstance:Any,nibType:AnyClass,superView:UIView)->UIView{
        
        let width=superView.bounds.width
        let height=superView.bounds.height
        
        let view=NibLoader.loadViewFromNib(name: name, selfInstance: selfInstance, nibType: nibType)
        
        view.frame=CGRect(x: 0, y: 0, width: width, height: height)
        view.heightAnchor.constraint(equalToConstant: height).isActive=true
        view.widthAnchor.constraint(equalToConstant: width).isActive=true
        
        superView.addSubview(view)
        
        return view

    }
}
