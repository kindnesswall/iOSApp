//
//  GiftTableViewCell.swift
//  app
//
//  Created by Hamed.Gh on 11/27/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {

    @IBOutlet var giftImage: UIImageView!
    @IBOutlet var giftTitle: UILabel!
    @IBOutlet var giftDate: UILabel!
    @IBOutlet var giftDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func filViews(gift:Gift) {
        giftTitle.text = gift.title
        giftDate.text = gift.createDateTime
        giftDescription.text = gift.description
    }
}
