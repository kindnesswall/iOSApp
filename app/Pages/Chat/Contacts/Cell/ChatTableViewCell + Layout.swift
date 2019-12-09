//
//  ChatTableViewCell + Layout.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/1/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

extension ChatTableViewCell {
    func layoutUserNameLabel() {

        let theView = self.userNameLabel
        let autoLayout = AutoLayoutHelper(view: theView)
        autoLayout.addConstraints(firstView: theView, secondView: self.contentView, leading: 100, trailing: -(userImageSize + 20), top: nil, bottom: nil)
        setCenterY(autoLayout: autoLayout, view: theView)
    }

    func layoutUserImage() {
        let theView = self.userImage
        let autoLayout = AutoLayoutHelper(view: theView)
        autoLayout.addConstraints(firstView: theView, secondView: self.contentView, leading: nil, trailing: -10, top: nil, bottom: nil)
        setCenterY(autoLayout: autoLayout, view: theView)
        autoLayout.addDimension(dimension: theView.widthAnchor, equationType: .equal, constant: self.userImageSize)
        autoLayout.addDimension(dimension: theView.heightAnchor, equationType: .equal, constant: self.userImageSize)
    }

    func layoutNotificationLabel() {
        let theView = self.notificationLabel
        let autoLayout = AutoLayoutHelper(view: theView)
        autoLayout.addConstraints(firstView: theView, secondView: self.contentView, leading: 10, trailing: nil, top: nil, bottom: nil)
        setCenterY(autoLayout: autoLayout, view: theView)
        autoLayout.addDimension(dimension: theView.heightAnchor, equationType: .equal, constant: 30)
        autoLayout.addDimension(dimension: theView.widthAnchor, equationType: .equal, constant: 50)
    }

    func setCenterY(autoLayout: AutoLayoutHelper, view: UIView) {
        autoLayout.addYAxisMultiplierConstraint(viewAnchor: view.centerYAnchor, superViewAnchor: self.contentView.centerYAnchor)
    }
}
