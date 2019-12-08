//
//  CharityTableViewCell.swift
//  app
//
//  Created by Hamed Ghadirian on 31.08.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class CharityTableViewCell: UITableViewCell {

    static let cellHeight: CGFloat = 91

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
