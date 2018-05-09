//
//  PopUpViewController.swift
//  app
//
//  Created by AmirHossein on 3/26/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    private var popUpView:PopUpView?
    
    var nibClass:AnyClass?
    
    var data:Any?
    
    private var submitHandler : ((Any?)->Void)?
    private var declineHandler : ((Any?)->Void)?
    
    func setSubmitHandler(_ submitHandler : ((Any?)->Void)?) {
        self.submitHandler=submitHandler
    }
    func setDeclineHandler(_ declineHandler : ((Any?)->Void)?) {
        self.declineHandler=declineHandler
    }
    
    enum PopUpAnimation{
        case modal
        case none
    }
    var popUpAnimation:PopUpAnimation = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        addDismissTapGesture()
        
        addPopUpView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showPopUpWithAnimation()
    }
    
//    private func addDismissTapGesture(){
//        let dismissTapGesture=UITapGestureRecognizer(target: self, action: #selector(self.dismissTapGestureAction))
//        self.view.addGestureRecognizer(dismissTapGesture)
//    }
//
//    @objc private func dismissTapGestureAction(){
//        dismissPopUpWithAnimation()
//    }
    
    private func addPopUpView(){
        
        guard let nibClass=nibClass else {
            return
        }
        
        let nibName=String(describing:nibClass.self)
        
        guard let popUpView=NibLoader.loadViewFromNib(name: nibName, owner: self, nibType: nibClass.self) as? PopUpView else {
            return
        }
        
        self.popUpView=popUpView
        
        popUpView.isUserInteractionEnabled=true
        popUpView.backgroundColor=UIColor.clear
        
        let width=self.view.frame.width
        let height=self.view.frame.height
        
        var yOffset:CGFloat=0
        popUpView.alpha=1
        
        switch popUpAnimation {
        case .modal:
            yOffset=height
        case .none:
            popUpView.alpha=0
        }
        popUpView.frame=CGRect(x: 0, y: yOffset, width: width , height: height)
        
        popUpView.controller=self
        popUpView.initPopUpView()
        
        self.view.addSubview(popUpView)
    }
    
    private func showPopUpWithAnimation(){
        
        switch popUpAnimation {
        case .modal:
            
            let height=self.view.frame.height
            UIView.animate(withDuration: 0.35) {
                self.popUpView?.center.y=height/2
            }
        case .none:
            
            UIView.animate(withDuration: 0.1) {
                self.popUpView?.alpha=1
            }
        }
    }
    
    private func dismissPopUpWithAnimation(completion: (() -> Void)? = nil){
        
        switch popUpAnimation {
        case .modal:
            
            let height=self.view.frame.height
            UIView.animate(withDuration: 0.35, animations: {
                self.popUpView?.center.y = (1.5*height)
            }) { (_) in
                self.dismiss(animated: false, completion: completion)
            }
            
        case .none:
            
            UIView.animate(withDuration: 0.1, animations: {
                self.popUpView?.alpha=0
            }) { (_) in
                self.dismiss(animated: false, completion: completion)
            }
        }
        
        
    }
    
    func submitPopUp(data:Any?=nil){
        self.dismissPopUp {
            self.submitHandler?(data)
        }
    }
    func declinePopUp(data:Any?=nil){
        self.dismissPopUp {
            self.declineHandler?(data)
        }
    }
    func dismissPopUp(completion: (() -> Void)? = nil){
        self.dismissPopUpWithAnimation(completion: completion)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
