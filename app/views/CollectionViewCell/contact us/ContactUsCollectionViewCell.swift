//
//  ContactUsCollectionViewCell.swift
//  app
//
//  Created by Amir Hossein on 12/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class ContactUsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(data:ContactUsViewController.ContactUsModel){
        logo.image = data.image
    }

}
