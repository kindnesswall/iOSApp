//
//  RequestsTableViewCell.swift
//  app
//
//  Created by Hamed.Gh on 12/19/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class RequestsTableViewCell: UITableViewCell {

    @IBOutlet var giftName: UILabel!
    
    @IBOutlet var numberOfRequestsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func fillUI(gift:Gift) {
        giftName.text = gift.title
        
        numberOfRequestsLbl.text = gift.requestCount?.CastNumberToPersian()
    }

}
