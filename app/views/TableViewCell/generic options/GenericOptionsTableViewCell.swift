//
//  GenericOptionsTableViewCell.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class GenericOptionsTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    
    func setValue(name:String?) {
        self.name.text=name
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
