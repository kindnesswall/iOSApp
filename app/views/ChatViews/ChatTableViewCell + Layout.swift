//
//  ChatTableViewCell + Layout.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/1/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation

extension ChatTableViewCell {
    func layoutUserNameLabel(){
        
        let autoLayout = AutoLayoutHelper(view: self.userNameLabel)
        autoLayout.addConstraints(firstView: self.userNameLabel, secondView: self.contentView, leading: 10, trailing: -100, top: 0, bottom: 0)
        autoLayout.addDimension(dimension: self.userNameLabel.heightAnchor, equationType: .equal, constant: 60)
    }
    
    func layoutNotificationLabel(){
        let autoLayout = AutoLayoutHelper(view: self.notificationLabel)
        autoLayout.addConstraints(firstView: self.notificationLabel, secondView: self.contentView, leading: nil, trailing: -10, top: 15, bottom: -15)
        autoLayout.addDimension(dimension: self.notificationLabel.widthAnchor, equationType: .equal, constant: 50)
    }
}
