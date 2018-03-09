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
    @IBOutlet weak var rowNumberLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setRow(request:Request) {
        callBtn.data = request as AnyObject
        messageBtn.data = request as AnyObject
        acceptRequestBtn.data = request as AnyObject
        rejectRequestBtn.data = request as AnyObject
    }
    
    func fillUI(request:Request, rowNumber:Int) {
        setRow(request: request)
        
        rowNumberLbl.text = "- \(rowNumber+1)".CastNumberToPersian()
        nameLbl.text = request.fromUser?.CastNumberToPersian()
    }
    
}
