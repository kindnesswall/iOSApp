//
//  UploadImageView.swift
//  app
//
//  Created by AmirHossein on 2/14/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class UploadImageView: UIView {

    weak var delegate: UploadImageViewDelegate?

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    
    private let viewModel = UploadImageViewModel()
    
    var uploadURL: String? {
        return viewModel.uploadURL
    }
    
    func download(url: String) {
        uploadFinished(url: url)
        guard let url = URL(string: url) else { return }
        imageView.kf.setImage(with: url)
    }
    func display(image: UIImage) {
        imageView.image = image
    }
    func uploadStarted(task: URLSessionUploadTask?) {
        viewModel.task = task
    }
    
    func setUpload(percent: Int) {
        progressLabel.text = "٪" + String(AppLanguage.getNumberString(number: String(percent)))
    }
    
    func uploadFinished(url: String) {
        viewModel.uploadURL = url
        shadowView.hide()
        progressLabel.hide()
    }
    func cancelUploadAndRemove() {
        viewModel.task?.cancel()
        removeFromSuperview()
    }
    func same(task: URLSessionUploadTask) -> Bool {
        return task === viewModel.task
    }

    @IBAction func cancelBtnAction(_ sender: Any) {
        self.delegate?.imageCanceled(imageView: self)
    }

}

protocol UploadImageViewDelegate: class {
    func imageCanceled(imageView: UploadImageView)
}
