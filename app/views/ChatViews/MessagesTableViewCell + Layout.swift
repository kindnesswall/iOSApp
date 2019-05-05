//
//  MessagesTableViewCell + Layout.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/1/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import Foundation

extension MessagesTableViewCell {
    func layoutMessageContentView(type: MessageUserType){
        let autoLayout = AutoLayoutHelper(view: self.messageContentView)
        switch type {
        case .user:
            autoLayout.addConstraints(firstView: self.messageContentView, secondView: self.contentView, leading: margin, trailing: nil, top: margin, bottom: -margin)
            autoLayout.addConstantConstraint(firstAnchor: self.messageContentView.trailingAnchor, secondAnchor: self.contentView.trailingAnchor, equationType: .lessThan, constant: -userMargin)
        case .others:
            autoLayout.addConstraints(firstView: self.messageContentView, secondView: self.contentView, leading: nil, trailing: -margin, top: margin, bottom: -margin)
            autoLayout.addConstantConstraint(firstAnchor: self.messageContentView.leadingAnchor, secondAnchor: self.contentView.leadingAnchor, equationType: .greaterThan, constant: userMargin)
        }
    }
    
    func layoutMessageTextLabel(type: MessageUserType){
        let autoLayout = AutoLayoutHelper(view: self.messageText)
        autoLayout.addConstraints(firstView: self.messageText, secondView: self.messageContentView, leading: textMargin, trailing: -textMargin, top: textMargin, bottom:nil)
    }
    
    func layoutTimeLabel(type: MessageUserType){
        let autoLayout = AutoLayoutHelper(view: self.timeLabel)
        autoLayout.addConstantConstraint(firstAnchor: self.timeLabel.topAnchor, secondAnchor: self.messageText.bottomAnchor, equationType: .equal, constant: textMargin)
        autoLayout.addConstraints(firstView: self.timeLabel, secondView: self.messageContentView, leading: textMargin, trailing: nil, top: nil, bottom: -textMargin)
    }
    
    func layoutStateLabel(type: MessageUserType){
        let autoLayout = AutoLayoutHelper(view: self.stateLabel)
        autoLayout.addConstantConstraint(firstAnchor: self.stateLabel.leadingAnchor, secondAnchor: self.timeLabel.trailingAnchor, equationType: .equal, constant: textMargin/2)
        autoLayout.addConstraints(firstView: self.stateLabel, secondView: self.timeLabel, leading: nil, trailing: nil, top: 0, bottom: 0)
        autoLayout.addConstraints(firstView: self.stateLabel, secondView: self.messageContentView, leading: nil, trailing: -textMargin/2, top: nil, bottom: nil)
        autoLayout.addDimension(dimension: self.stateLabel.widthAnchor, equationType: .lessThan, constant: stateLabelMaxWidth)
    }
}
