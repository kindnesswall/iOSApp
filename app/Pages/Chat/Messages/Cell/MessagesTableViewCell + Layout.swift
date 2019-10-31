//
//  MessagesTableViewCell + Layout.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/1/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

extension MessagesTableViewCell {
    
    func layoutContainerStackView(){
        let autoLayout = AutoLayoutHelper(view: self.containerStackView)
        autoLayout.addConstraints(firstView: self.containerStackView, secondView: self.contentView, leading: 0, trailing: 0, top: 0, bottom: 0)
    }
    
    func layoutIsNewMessageView(){
        let autoLayout = AutoLayoutHelper(view: self.isNewMessageView)
        autoLayout.addDimension(dimension: self.isNewMessageView.heightAnchor, equationType: .equal, constant: self.isNewMessageHeight)
    }
    
    func layoutMessageContentView(type: MessageUserType){
        
        let subView = self.messageContentView
        let superView = self.messageContainerView
        
        let autoLayout = AutoLayoutHelper(view: subView)
        switch type {
        case .others:
            autoLayout.addConstraints(firstView: subView, secondView: superView, leading: hMargin, trailing: nil, top: vMargin, bottom: -vMargin)
            autoLayout.addConstantConstraint(firstAnchor: subView.trailingAnchor, secondAnchor: superView.trailingAnchor, equationType: .lessThan, constant: -userMargin)
        case .user:
            autoLayout.addConstraints(firstView: subView, secondView: superView, leading: nil, trailing: -hMargin, top: vMargin, bottom: -vMargin)
            autoLayout.addConstantConstraint(firstAnchor: subView.leadingAnchor, secondAnchor: superView.leadingAnchor, equationType: .greaterThan, constant: userMargin)
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
    
    func layoutIsNewMessageLabel(){
        let autoLayout = AutoLayoutHelper(view: self.isNewMessageLabel)
        autoLayout.addConstraints(firstView: self.isNewMessageLabel, secondView: self.isNewMessageView, leading: nil, trailing: nil, top: 0, bottom: 0)
        autoLayout.addXAxisMultiplierConstraint(viewAnchor: self.isNewMessageLabel.centerXAnchor, superViewAnchor: self.isNewMessageView.centerXAnchor)
        autoLayout.addDimension(dimension: self.isNewMessageLabel.widthAnchor, equationType: .equal, constant: self.isNewMessageLabelWidth)
    }
    
    func layoutIsNewMessageLineLabel(line:UILabel,isLeft:Bool){
        let autoLayout = AutoLayoutHelper(view: line)
        autoLayout.addDimension(dimension: line.heightAnchor, equationType: .equal, constant: 1)
        autoLayout.addYAxisMultiplierConstraint(viewAnchor: line.centerYAnchor, superViewAnchor: self.isNewMessageView.centerYAnchor)
        
        let superViewAnchor = isLeft ? self.isNewMessageView.leadingAnchor : self.isNewMessageView.trailingAnchor
        autoLayout.addConstantConstraint(
            firstAnchor: isLeft ? line.leadingAnchor : line.trailingAnchor, secondAnchor: superViewAnchor, equationType: .equal, constant: isLeft ? hMargin : -hMargin)

        let centerLabelAnchor = isLeft ? self.isNewMessageLabel.leadingAnchor : self.isNewMessageLabel.trailingAnchor
        autoLayout.addConstantConstraint(
            firstAnchor: isLeft ? line.trailingAnchor : line.leadingAnchor, secondAnchor: centerLabelAnchor, equationType: .equal, constant: isLeft ? -hMargin : hMargin)
        
    }
}
