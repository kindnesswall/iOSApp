//
//  Image.swift
//  App
//
//  Created by Amir Hossein on 1/17/19.
//

import Foundation

class ImageInput: Codable {
    var image: Data
    var imageFormat: ImageInputFormat?

    init(image: Data, imageFormat: ImageInputFormat?) {
        self.image=image
        self.imageFormat=imageFormat
    }
}

enum ImageInputFormat: String, Codable {
    case jpeg
}

class ImageOutput: Codable {
    var address: String
}
