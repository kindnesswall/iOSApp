//
//  RequestToAGiftTableViewCell.swift
//  app
//
//  Created by Hamed.Gh on 12/19/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestToAGiftTableViewCell: UITableViewCell {

    @IBOutlet var nameLbl: UILabel!
    
    @IBOutlet var callBtn: ButtonWithData!
    
    @IBOutlet var messageBtn: ButtonWithData!
    @IBOutlet var acceptRequestBtn: ButtonWithData!
    @IBOutlet var rejectRequestBtn: ButtonWithData!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setRow(number:Int) {
        callBtn.data = number as AnyObject
        messageBtn.data = number as AnyObject
        acceptRequestBtn.data = number as AnyObject
        rejectRequestBtn.data = number as AnyObject
    }
    
    func fillUI(request:Request, rowNumber:Int) {
        setRow(number: rowNumber)
        
        nameLbl.text = request.fromUser
    }
    
}
