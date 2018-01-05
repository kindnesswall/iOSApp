//
//  SectionView.swift
//  VC
//
//  Created by maede on 11/1/17.
//  Copyright © 2017 Aseman. All rights reserved.
//

import UIKit

class SectionView: UIView {

    @IBOutlet weak var title: UILabel!
    
    func setTitle(title:String){
        self.title.text = title
    }

}
