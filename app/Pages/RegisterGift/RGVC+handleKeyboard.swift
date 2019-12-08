//
//  RGVC+handleKeyboard.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import XLActionController

extension RegisterGiftViewController {

    @objc func dismissKeyBoard() {
        self.titleTextView.resignFirstResponder()
        self.priceTextView.resignFirstResponder()
        self.descriptionTextView.resignFirstResponder()
    }

    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

            let lastContentOffset=self.contentScrollView.contentOffset
            let offset: CGFloat=60+10+150+10
            if lastContentOffset.y<offset {
                self.contentScrollView.contentOffset=CGPoint(x: lastContentOffset.x, y: offset)
            }
            //            print("keyboard:\(keyboardSize.height)")
            self.contentScrollView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {

        self.contentScrollView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        //        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {}

    }

    @IBAction func uploadBtnClicked(_ sender: Any) {
        let actionController = SkypeActionController()

        actionController.addAction(Action( LanguageKeys.camera.localizedString, style: .default, handler: { _ in

            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            self.imagePicker.delegate = self

            self.present(self.imagePicker, animated: true, completion: nil)

        }))

        actionController.addAction(Action( LanguageKeys.gallery.localizedString, style: .default, handler: { _ in

            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.delegate = self

            self.present(self.imagePicker, animated: true, completion: nil)

        }))

        present(actionController, animated: true, completion: nil)

    }
}

extension RegisterGiftViewController: UINavigationControllerDelegate {

}
