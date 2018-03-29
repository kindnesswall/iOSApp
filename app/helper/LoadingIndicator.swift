
import Foundation
import UIKit

public class LoadingIndicator {
    
    
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
    
    
    init(view:UIView,offset:CGFloat=0,color:UIColor=AppColor.tintColor) {
        
        loadingIndicatorType = .view
        
        self.activityIndicator.backgroundColor=UIColor.clear
        self.activityIndicator.color=color
        self.activityIndicator.hidesWhenStopped=true
        view.addSubview(self.activityIndicator)
        self.activityIndicator.isHidden=true
        
        //important !
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.heightAnchor.constraint(equalToConstant: 100).isActive=true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        self.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset).isActive=true
        
    }

    init(viewBelowTableView:UIView,cellHeight:CGFloat,color:UIColor=AppColor.tintColor) {
        
        
        loadingIndicatorType = .view
        
        let indicatorSize:CGFloat=100
        
        self.activityIndicator.backgroundColor=UIColor.clear
        self.activityIndicator.color=color
        self.activityIndicator.hidesWhenStopped=true
        viewBelowTableView.insertSubview(self.activityIndicator, at: 0)
        self.activityIndicator.isHidden=true
        
        //important !
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.activityIndicator.heightAnchor.constraint(equalToConstant: indicatorSize).isActive=true
        self.activityIndicator.widthAnchor.constraint(equalToConstant: indicatorSize).isActive=true
        
        self.activityIndicator.centerXAnchor.constraint(equalTo: viewBelowTableView.centerXAnchor).isActive=true
        
        self.activityIndicator.centerYAnchor.constraint(equalTo: viewBelowTableView.bottomAnchor, constant: (-1*cellHeight/2)-(indicatorSize/2)).isActive=true
        
        
    }
    
    init(navigationItem:UINavigationItem,type:NavigationItemType,replacedNavigationBarButton:UIBarButtonItem?,color:UIColor=AppColor.tintColor) {
        
        self.navigationItem=navigationItem
        self.replacedNavigationBarButton=replacedNavigationBarButton
        
        switch type {
        case .left:
            loadingIndicatorType = .leftNavigationItem
        case .right:
            loadingIndicatorType = .rightNavigationItem
        }
        
        self.activityIndicator.color=color
        self.activityIndicator.hidesWhenStopped=true
        
    }

    
    func startLoading(){
        
        switch loadingIndicatorType {
        case .view:
            self.activityIndicator.isHidden=false
        case .leftNavigationItem:
            let activityItem=UIBarButtonItem(customView: activityIndicator)
            self.navigationItem?.leftBarButtonItems=[activityItem]
        case .rightNavigationItem:
            let activityItem=UIBarButtonItem(customView: activityIndicator)
            self.navigationItem?.rightBarButtonItems=[activityItem]
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
                self.navigationItem?.leftBarButtonItems=[replacedNavigationBarButton]
            } else {
                self.navigationItem?.leftBarButtonItems=[]
            }
        case .rightNavigationItem:
            if let replacedNavigationBarButton=self.replacedNavigationBarButton {
                self.navigationItem?.rightBarButtonItems=[replacedNavigationBarButton]
            } else {
                self.navigationItem?.rightBarButtonItems=[]
            }
        }
        
       
    }
    
    
}
