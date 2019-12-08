//
//  MyWallSegmentControl.swift
//  app
//
//  Created by Amir Hossein on 11/20/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class MyWallSegmentControl: UIView {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    var segmentChanged: (() -> Void)?

    override func awakeFromNib() {
        configSegmentControl()
    }

    func configSegmentControl() {
        self.segmentControl.tintColor=AppColor.Tint
        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: AppFont.getLightFont(size: 13)], for: .normal)
    }

    @IBAction func segmentChangedAction(_ sender: Any) {
        self.segmentChanged?()
    }

}
