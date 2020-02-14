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

        let autoLayout = AutoLayoutHelper(view: userNameLabel)
        autoLayout.addConstantConstraint(firstAnchor: userNameLabel.trailingAnchor, secondAnchor: userImage.leadingAnchor, equationType: .equal, constant: -margin)
        setCenterY(autoLayout: autoLayout, view: userNameLabel)
    }
    
    func layoutCharityNameContainer() {
        let autoLayout = AutoLayoutHelper(view: charityNameContainer)
        autoLayout.addConstantConstraint(firstAnchor: charityNameContainer.trailingAnchor, secondAnchor: userNameLabel.leadingAnchor, equationType: .equal, constant: -margin)
        autoLayout.addConstantConstraint(firstAnchor: charityNameContainer.leadingAnchor, secondAnchor: contentView.leadingAnchor, equationType: .greaterThan, constant: 50 + (2 * margin))
        setCenterY(autoLayout: autoLayout, view: charityNameContainer)
    }
    func layoutCharityNameLabel() {
        let autoLayout = AutoLayoutHelper(view: charityNameLabel)
        autoLayout.addConstraints(firstView: charityNameLabel, secondView: charityNameContainer, leading: padding, trailing: -padding, top: padding, bottom: -padding)
    }

    func layoutUserImage() {
        let theView = self.userImage
        let autoLayout = AutoLayoutHelper(view: theView)
        autoLayout.addConstraints(firstView: theView, secondView: self.contentView, leading: nil, trailing: -margin, top: nil, bottom: nil)
        setCenterY(autoLayout: autoLayout, view: theView)
        autoLayout.addDimension(dimension: theView.widthAnchor, equationType: .equal, constant: self.userImageSize)
        autoLayout.addDimension(dimension: theView.heightAnchor, equationType: .equal, constant: self.userImageSize)
    }

    func layoutNotificationLabel() {
        let theView = self.notificationLabel
        let autoLayout = AutoLayoutHelper(view: theView)
        autoLayout.addConstraints(firstView: theView, secondView: self.contentView, leading: margin, trailing: nil, top: nil, bottom: nil)
        setCenterY(autoLayout: autoLayout, view: theView)
        autoLayout.addDimension(dimension: theView.heightAnchor, equationType: .equal, constant: 30)
        autoLayout.addDimension(dimension: theView.widthAnchor, equationType: .equal, constant: 50)
    }

    func setCenterY(autoLayout: AutoLayoutHelper, view: UIView) {
        autoLayout.addYAxisMultiplierConstraint(viewAnchor: view.centerYAnchor, superViewAnchor: self.contentView.centerYAnchor)
    }
}
