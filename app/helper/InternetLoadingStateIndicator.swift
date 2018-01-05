
import Foundation
import UIKit

public class InternetLoadingStateIndicator {
    
    var superView:UIView!
    
    var superNavigationItem:UINavigationItem?
    var original_NavigationItem:UIBarButtonItem?
    
    let activityIndicator=UIActivityIndicatorView()
    
    var isNavbar=false
    
    convenience public init(view:UIView) {
     
        self.init(view: view,offset:0)

        
    }
    
    public init(view:UIView,offset:CGFloat) {
        self.superView=view
        isNavbar=false
        
        self.activityIndicator.backgroundColor=view.backgroundColor
        self.activityIndicator.color=UIColor.black
        self.activityIndicator.hidesWhenStopped=true
        self.superView.addSubview(self.activityIndicator)
        self.activityIndicator.isHidden=true
        
        //important !
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive=true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: superView.centerXAnchor).isActive=true
        self.activityIndicator.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: offset).isActive=true
        
        
    }

    
    public init(navigationItem:UINavigationItem,navbarItem:UIBarButtonItem) {
        
        self.superNavigationItem=navigationItem
        self.original_NavigationItem=navbarItem
        isNavbar=true
        self.activityIndicator.color=UIColor.white
        self.activityIndicator.hidesWhenStopped=true
        
    }

    
    public func startLoading(){
        
        if isNavbar {
            let activityItem=UIBarButtonItem(customView: activityIndicator)
            self.superNavigationItem?.leftBarButtonItem=activityItem
        } else {
            self.activityIndicator.isHidden=false
        }
        self.activityIndicator.startAnimating()
    }
    
    public func endLoading(){
        self.activityIndicator.stopAnimating()
        
        if isNavbar {
            if let original_NavigationItem=self.original_NavigationItem {
                self.superNavigationItem?.leftBarButtonItem=original_NavigationItem
            }
            
        } else {
            self.activityIndicator.isHidden=true
        }
    }
    
    
}
