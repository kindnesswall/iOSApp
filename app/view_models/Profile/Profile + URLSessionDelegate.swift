//
//  Profile + URLSessionDelegate.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

extension ProfileViewModel:URLSessionTaskDelegate{

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        print("byte :: \(bytesSent) in : \(totalBytesSent) from : \(totalBytesExpectedToSend)")
        
        var percent = Int(Float(totalBytesSent * 100)/Float(totalBytesExpectedToSend))
        if percent == 100 {
            percent = 99
        }
        
        self.delegate?.updateUploadImage(percent: percent)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
    
}
