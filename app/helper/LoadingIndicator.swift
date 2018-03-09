
import Foundation
import UIKit

public class LoadingIndicator {
    
    weak var superView:UIView?
    
    weak var navigationItem:UINavigationItem?
    weak var replacedNavigationBarButton:UIBarButtonItem?
    
    let activityIndicator=UIActivityIndicatorView()
    
    var loadingIndicatorType:LoadingIndicatorType = .view
    
    enum LoadingIndicatorType {
        case view
        case rightNavigationItem
        case leftNavigationItem
    }
    enum NavigationItemType {
        case right
        case left
    }
    
    convenience public init(view:UIView) {
     
        self.init(view: view,offset:0)
        
    }
    
    init(view:UIView,offset:CGFloat) {
        self.superView=view
        loadingIndicatorType = .view
        
        self.activityIndicator.backgroundColor=view.backgroundColor
        self.activityIndicator.color=UIColor.black
        self.activityIndicator.hidesWhenStopped=true
        self.superView?.addSubview(self.activityIndicator)
        self.activityIndicator.isHidden=true
        
        //important !
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive=true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive=true
        
        
    }

    
    init(navigationItem:UINavigationItem,type:NavigationItemType,navbarItem:UIBarButtonItem) {
        
        self.navigationItem=navigationItem
        self.replacedNavigationBarButton=navbarItem
        
        switch type {
        case .left:
            loadingIndicatorType = .leftNavigationItem
        case .right:
            loadingIndicatorType = .rightNavigationItem
        }
        
        self.activityIndicator.color=UIColor.white
        self.activityIndicator.hidesWhenStopped=true
        
    }

    
    func startLoading(){
        
        switch loadingIndicatorType {
        case .view:
            self.activityIndicator.isHidden=false
        case .leftNavigationItem:
            let activityItem=UIBarButtonItem(customView: activityIndicator)
            self.navigationItem?.leftBarButtonItem=activityItem
        case .rightNavigationItem:
            let activityItem=UIBarButtonItem(customView: activityIndicator)
            self.navigationItem?.rightBarButtonItem=activityItem
        }
        
        self.activityIndicator.startAnimating()
    }
    
    func stopLoading(){
        self.activityIndicator.stopAnimating()
        
        switch loadingIndicatorType {
        case .view:
            self.activityIndicator.isHidden=true
        case .leftNavigationItem:
            
            if let replacedNavigationBarButton=self.replacedNavigationBarButton {
                self.navigationItem?.leftBarButtonItem=replacedNavigationBarButton
            }
        case .rightNavigationItem:
            if let replacedNavigationBarButton=self.replacedNavigationBarButton {
                self.navigationItem?.rightBarButtonItem=replacedNavigationBarButton
            }
        }
        
       
    }
    
    
}
