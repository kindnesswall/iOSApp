//
//  StatisticTableViewCell.swift
//  app
//
//  Created by Amir Hossein on 8/24/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class StatisticTableViewCell: UITableViewCell {

    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    func setUI(key: String, value: String) {
        keyLabel.text = key
        valueLabel.text = value
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
