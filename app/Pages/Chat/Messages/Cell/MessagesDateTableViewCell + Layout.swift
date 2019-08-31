//
//  MessagesDateTableViewCell + Layout.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/20/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation

extension MessagesDateTableViewCell {
    
    func layoutDateLabel(){
        let autoLayout = AutoLayoutHelper(view: self.dateLabel)
        autoLayout.addConstraints(firstView: self.dateLabel, secondView: self.contentView, leading: 8, trailing: -8, top: 0, bottom: 0)
    }
    
}
