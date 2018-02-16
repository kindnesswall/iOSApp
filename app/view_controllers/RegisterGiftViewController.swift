//
//  RegisterGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/12/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import XLActionController
import CropViewController

class RegisterGiftViewController: UIViewController {

    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var dateStatusBtn: UIButton!
    @IBOutlet weak var uploadedImageStack: UIStackView!
    var uploadedImageViews=[UploadImageView]()
    
    
    @IBOutlet var uploadBtn: UIButton!

    
    @IBOutlet weak var categoryBtn: UIButton!
    
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(self.tapGestureAction))
        
        contentStackView.addGestureRecognizer(tapGesture)
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func tapGestureAction(){
        dismissKeyBoard()
    }
    
    func dismissKeyBoard(){
        self.titleTextView.resignFirstResponder()
    }

    @IBAction func categoryBtnClicked(_ sender: Any) {
        
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.category
        controller.completionHandler={ [weak self]
            (id,name) in self?.categoryBtn.setTitle(name, for: .normal)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func dateStatusBtnAction(_ sender: Any) {
        let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
        controller.option = OptionsListViewController.Option.dateStatus
        controller.completionHandler={ [weak self]
            (id,name) in self?.dateStatusBtn.setTitle(name, for: .normal)
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func uploadBtnClicked(_ sender: Any) {
        let actionController = SkypeActionController()
        
        actionController.addAction(Action("دوربین", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self
            
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        actionController.addAction(Action("گالری تصاویر", style: .default, handler: { action in
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self
    
            self.present(self.imagePicker, animated: true, completion: nil)
            
        }))
        
        present(actionController, animated: true, completion: nil)


    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="ثبت هدیه"
        
    }
    
   
    
}

extension RegisterGiftViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let selectedImage=selectedImage {
            
            
            let cropViewController = CropViewController(image: selectedImage)
            cropViewController.delegate = self
            
            
            picker.dismiss(animated: true, completion: nil)
            
            present(cropViewController, animated: false, completion: nil)
            
            
            
            
        } else {
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension RegisterGiftViewController : CropViewControllerDelegate {
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
//        self.croppedRect = cropRect
//        self.croppedAngle = angle
//        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        
        uploadImage(selectedImage: image)
        self.dismiss(animated: false, completion: nil)
    }
    
//    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
////        self.croppedRect = cropRect
////        self.croppedAngle = angle
////        updateImageViewWithImage(image, fromCropViewController: cropViewController)
//        uploadImage(selectedImage: image)
//    }
    
    func uploadImage(selectedImage: UIImage) {
//        if let token=UserDefaults.standard.string(forKey: AppConstants.Authorization) {
        
        let uploadedImageView=NibLoader.loadViewFromNib(name: "UploadImageView", owner: self, nibType: UploadImageView.self) as! UploadImageView
        uploadedImageView.widthAnchor.constraint(equalToConstant: 100).isActive=true
        
        uploadedImageView.imageView.image=selectedImage
        
        self.uploadedImageViews.append(uploadedImageView)
        self.uploadedImageStack.addArrangedSubview(uploadedImageView)
        
        APIRequest.uploadImageTask(url: APIURLs.Upload, session: &uploadedImageView.uploadSession, task: &uploadedImageView.uploadTask,delegate:self, image: selectedImage, complitionHandler: { [weak self] (data, response, error) in
            
//            print("hey :: ::")
//            APIRequest.logReply(data: data)
            
//            print("error :: ::")
            if let response = response as? HTTPURLResponse {
                print((response).statusCode)
                
                if response.statusCode >= 200 && response.statusCode <= 300 {
                    FlashMessage.showMessage(body: "آپلود با موفقیت انجام شد",theme: .success)
                }else{
                    FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
                }
            }
            
            guard error==nil else {
                FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
                return
            }
            
            guard let uploadIndex=self?.findIndexOfUploadedImage(task: uploadedImageView.uploadTask) else {
                return
            }
            
            self?.uploadedImageViews[uploadIndex].shadowView.isHidden=true
            self?.uploadedImageViews[uploadIndex].progressLabel.isHidden = true
            
            //                if let json=APIRequest.getJsonDic(fromData: data) {
            //                    if let status = json["status"] as? String,
            //                        status == APIStatus.DONE,
            //                        let url = json["avatar_url"] as? String{
            //
            //                        FlashMessage.showMessage(body: "آپلود با موفقیت انجام شد",theme: .success)
            //
            //                        self?.profile.avatar_url = url
            //                        return
            //                    }
            //                }
            //                FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
            
        })
    }
    
    func findIndexOfUploadedImage(task:URLSessionTask?)->Int?{
        
        guard let task = task else {
            return nil
        }
        
        for i in 0..<self.uploadedImageViews.count {
            if self.uploadedImageViews[i].uploadTask==task {
                return i
            }
        }
        return nil
        
    }
}



extension RegisterGiftViewController:URLSessionTaskDelegate{
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("byte :: \(bytesSent) in : \(totalBytesSent) from : \(totalBytesExpectedToSend)")
        
        var percent = Int(Float(totalBytesSent * 100)/Float(totalBytesExpectedToSend))
        if percent == 100 {
            percent = 99
        }
        
        guard let uploadIndex=findIndexOfUploadedImage(task: task) else {
            return
        }
        self.uploadedImageViews[uploadIndex].progressLabel.text = "٪" + UIFunctions.CastNumberToPersian(input: percent)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}




extension RegisterGiftViewController:UINavigationControllerDelegate{
    
}
