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
    
    private func addDismissTapGesture(){
        let dismissTapGesture=UITapGestureRecognizer(target: self, action: #selector(self.dismissTapGestureAction))
        self.view.addGestureRecognizer(dismissTapGesture)
    }
    
    @objc private func dismissTapGestureAction(){
        dismissPopUpWithAnimation()
    }
    
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
        
        popUpView.frame=CGRect(x: 0, y: height, width: width , height: height)
        
        popUpView.controller=self
        popUpView.initPopUpView()
        
        self.view.addSubview(popUpView)
    }
    
    private func showPopUpWithAnimation(){
        let height=self.view.frame.height
        
        UIView.animate(withDuration: 0.35) {
            self.popUpView?.center.y=height/2
        }
    }
    
    private func dismissPopUpWithAnimation(){
        let height=self.view.frame.height
        
        UIView.animate(withDuration: 0.35, animations: {
            self.popUpView?.center.y = (1.5*height)
        }) { (_) in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func submitPopUp(data:Any?=nil){
        self.submitHandler?(data)
        self.dismissPopUp()
    }
    func declinePopUp(data:Any?=nil){
        self.declineHandler?(data)
        self.dismissPopUp()
    }
    func dismissPopUp(){
        self.dismissPopUpWithAnimation()
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
