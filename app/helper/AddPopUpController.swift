//
//  AddPopUp.swift
//  LMS
//
//  Created by AmirHossein on 6/24/17.
//  Copyright © 2017 aseman. All rights reserved.
//

import Foundation
import UIKit

public class AddPopUpController {
    
    let appDelegate=UIApplication.shared.delegate
    
    var nibName=""
    public var data:Any?
    
    var popUpView:PopUpView?
    var shadowView:UIView?
    var shadowTapGesture:UITapGestureRecognizer?
    var popUpTapGesture:UITapGestureRecognizer?
    
    var canHide=true
    
    weak var selfInstance:AnyObject!
    var nibType:AnyClass!
    
    weak var parentView:UIView!
    
    var closeComplition:()->Void
    var submitComplition:()->Void
    
    public init(nibName:String,selfInstance:AnyObject,nibType:AnyClass,parentView:UIView,data:Any?, closeComplition: @escaping ()->Void,submitComplition: @escaping ()->Void) {
        
        self.nibName=nibName
        self.data=data
        
        self.closeComplition = closeComplition
        self.submitComplition = submitComplition
        self.selfInstance=selfInstance
        self.nibType=nibType
        self.parentView=parentView
        
    }
    
    convenience public init (nibName:String,
                             selfInstance:AnyObject,
                             nibType:AnyClass,
                             parentView:UIView,
                             data:Any?,
                             closeComplition: @escaping ()->Void,
                             submitComplition: @escaping ()->Void,
                             canHide:Bool) {
        
        self.init(
            nibName: nibName,
            selfInstance: selfInstance,
            nibType: nibType,
            parentView: parentView,
            data: data, closeComplition: closeComplition,
            submitComplition: submitComplition)
        
        self.canHide=canHide
    }
    
    deinit {
        hidePopUp()
    }
    
    public func showPopUp(){
        
        if popUpView==nil{
            popUpView=NibLoader.loadViewFromNib(name: nibName, owner: selfInstance, nibType: nibType) as? PopUpView
            popUpView?.controller=self
            
            popUpView?.initPopUp()
            popUpView?.backgroundColor=UIColor.clear
            
            shadowTapGesture=UITapGestureRecognizer(target: self, action: #selector(self.shadowBtnClicked))
            popUpTapGesture=UITapGestureRecognizer(target: self, action: #selector(self.popUpGesture_Tapped))
            
            popUpView?.addGestureRecognizer(shadowTapGesture!)
            popUpView?.subviews.first?.addGestureRecognizer(popUpTapGesture!)
            
            shadowView=UIView()
            
            
            shadowView?.backgroundColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        }
        
        let width=appDelegate?.window??.frame.width ?? 0
        let height=appDelegate?.window??.frame.height ?? 0
        layoutPopUp()
        
        popUpView!.frame=CGRect(x: 0, y: height, width: width, height: height)
        //        popUpView!.widthAnchor.constraint(equalToConstant: width).isActive=true
        //        popUpView!.heightAnchor.constraint(equalToConstant: height).isActive=true
        
        
        
        addViewModalAnimated(view:popUpView!)
    }
    
    public func layoutPopUp(){
        
        let width=appDelegate?.window??.frame.width ?? 0
        let height=appDelegate?.window??.frame.height ?? 0
        
        shadowView!.frame=CGRect(x: 0, y: 0, width: width, height: height)
        shadowView!.widthAnchor.constraint(equalToConstant: width).isActive=true
        shadowView!.heightAnchor.constraint(equalToConstant: height).isActive=true
    }
    
    private func addViewModalAnimated(view:UIView){
        
        
        let height=appDelegate?.window??.frame.height ?? 0
        
        self.parentView.addSubview(shadowView!)
        
        //        UIView.transition(from: self.tabBarController!.view, to: view, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        
        //        let width=appDelegate.window?.frame.width ?? 0
        
        self.parentView.addSubview(view)
        
        
        
        UIView.animate(withDuration: 0.35, animations: {
            view.center.y = (height/2)
        }) { bool in
            
        }
    }
    
    public func hideAndSuccess(){
        hidePopUp()
        submitComplition()
    }
    
    public func hidePopUp(){
        
        self.popUpView?.popUpWillHide()
        
        if let popUpView=popUpView {
            removeViewModal(view: popUpView,shadowView: shadowView!)
        }
    }
    
    
    @objc private func shadowBtnClicked(){
        
        if canHide {
            hidePopUp()
        }
        
    }
    @objc private func popUpGesture_Tapped(){
        
    }
    
    private func removeViewModal(view:UIView,shadowView:UIView){
        
        //        UIView.transition(from:view , to: self.tabBarController!.view, duration: 0.35, options: UIViewAnimationOptions.transitionFlipFromRight, completion: nil)
        
        
        
        let height=appDelegate?.window??.frame.height ?? 0
        
        
        
        UIView.animate(withDuration: 0.35, animations: {
            
            view.center.y = 1.5*height
            
        }, completion: { (isCompleted:Bool) in
            
            view.removeFromSuperview()
            shadowView.removeFromSuperview()
            
            
        })
        
        
        
    }
    
    
}
