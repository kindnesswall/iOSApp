//
//  RegisterGiftViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/12/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RegisterGiftViewController: UIViewController {

    @IBOutlet var uploadBtn: UIButton!
    @IBOutlet var selectedImage: UIImageView!
    @IBOutlet var precentLbl: UILabel!
    @IBOutlet var uploadedImage: UIImageView!
    
    var uploadSession:Foundation.URLSession?
    var uploadTask:URLSessionDataTask?
    
    let imagePicker = UIImagePickerController()

    @IBAction func uploadBtnClicked(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

extension RegisterGiftViewController:UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if let selectedImage=selectedImage {
            self.selectedImage.image = selectedImage
        }
        
        if let token=UserDefaults.standard.string(forKey: AppConstants.USER_TOKEN) {
            APIRequest.uploadImageTask(url: APIURLs.Upload, session: &uploadSession, task: &uploadTask,delegate:self, image: selectedImage, complitionHandler: { [weak self] (data, response, error) in
                
                print("hey :: ::")
                APIRequest.logReply(data: data)
                
                print("error :: ::")
                if let response = response as? HTTPURLResponse {
                    print((response).statusCode)
                    
                    if response.statusCode >= 200 && response.statusCode <= 300 {
                        FlashMessage.showMessage(body: "آپلود با موفقیت انجام شد",theme: .success)
                    }else{
                        FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
                    }
                }
                
                self?.precentLbl.isHidden = true
                guard error==nil else {
                    FlashMessage.showMessage(body: "آپلود عکس با مشکل روبه‌رو شد",theme: .warning)
                    return
                }
                
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
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RegisterGiftViewController:URLSessionTaskDelegate{
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("byte :: \(bytesSent) in : \(totalBytesSent) from : \(totalBytesExpectedToSend)")
        
        var percent = Int(Float(totalBytesSent * 100)/Float(totalBytesExpectedToSend))
        if percent == 100 {
            percent = 99
        }
        self.precentLbl.text = "٪" + UIFunctions.CastNumberToPersian(input: percent)
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}

extension RegisterGiftViewController:UINavigationControllerDelegate{
    
}
