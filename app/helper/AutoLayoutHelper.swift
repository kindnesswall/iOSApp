//
//  AutoLayoutHelper.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/15/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit


class AutoLayoutHelper {
    
    enum EquationType {
        case equal
        case greaterThan
        case lessThan
    }
    
    init(view:UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addConstantConstraint<T>(firstAnchor:NSLayoutAnchor<T>,
                                   secondAnchor:NSLayoutAnchor<T>,
                              equationType:EquationType,
                              constant:CGFloat,
                              priority:UILayoutPriority? = nil){
        
        let constraint : NSLayoutConstraint
        switch equationType {
        case .equal:
            constraint = firstAnchor.constraint(equalTo: secondAnchor, constant: constant)
        case .greaterThan:
            constraint = firstAnchor.constraint(greaterThanOrEqualTo: secondAnchor, constant: constant)
        case .lessThan:
            constraint = firstAnchor.constraint(lessThanOrEqualTo: secondAnchor, constant: constant)
        }
        
        activateConstraint(constraint: constraint, priority: priority)
        
    }
    
    func addDimension(dimension:NSLayoutDimension,
                                         equationType:EquationType,
                                         constant:CGFloat,
                                         priority:UILayoutPriority? = nil){
        
        let constraint : NSLayoutConstraint
        switch equationType {
        case .equal:
            constraint = dimension.constraint(equalToConstant: constant)
        case .greaterThan:
            constraint = dimension.constraint(greaterThanOrEqualToConstant: constant)
        case .lessThan:
            constraint = dimension.constraint(lessThanOrEqualToConstant: constant)
        }
        
        activateConstraint(constraint: constraint, priority: priority)
        
    }
    
    func addXAxisMultiplierConstraint(viewAnchor:NSLayoutXAxisAnchor,
                                   superViewAnchor:NSLayoutXAxisAnchor,
                                   equationType:EquationType = .equal,
                                   multiplier:CGFloat = 1,
                                   priority:UILayoutPriority? = nil){
        
        let constraint : NSLayoutConstraint
        switch equationType {
        case .equal:
            constraint = viewAnchor.constraint(equalToSystemSpacingAfter: superViewAnchor, multiplier: multiplier)
            
        case .greaterThan:
            constraint = viewAnchor.constraint(greaterThanOrEqualToSystemSpacingAfter: superViewAnchor, multiplier: multiplier)
            
        case .lessThan:
            constraint = viewAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: superViewAnchor, multiplier: multiplier)
        }
        
        activateConstraint(constraint: constraint, priority: priority)
        
    }
    
    func addYAxisMultiplierConstraint(viewAnchor:NSLayoutYAxisAnchor,
                                   superViewAnchor:NSLayoutYAxisAnchor,
                                   equationType:EquationType = .equal,
                                   multiplier:CGFloat = 1,
                                   priority:UILayoutPriority? = nil){
        
        let constraint : NSLayoutConstraint
        switch equationType {
        case .equal:
            constraint = viewAnchor.constraint(equalToSystemSpacingBelow: superViewAnchor, multiplier: multiplier)
            
        case .greaterThan:
            constraint = viewAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: superViewAnchor, multiplier: multiplier)
            
        case .lessThan:
            constraint = viewAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: superViewAnchor, multiplier: multiplier)
        }
        
        activateConstraint(constraint: constraint, priority: priority)
        
    }
    
    
    func addConstraints(firstView:UIView,
                               secondView:UIView,
                               leading:CGFloat?,
                               trailing:CGFloat?,
                               top:CGFloat?,
                               bottom:CGFloat?,
                               leadingPriority:UILayoutPriority? = nil,
                               trailingPriority:UILayoutPriority? = nil,
                               topPriority:UILayoutPriority? = nil,
                               bottomPriority:UILayoutPriority? = nil){
        
        
        if let leading=leading{
            let leadingConstraint = firstView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor, constant: leading)
            activateConstraint(constraint: leadingConstraint, priority: leadingPriority)
        }
        if let trailing=trailing{
            let trailingConstraint = firstView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor, constant: trailing)
            activateConstraint(constraint: trailingConstraint, priority: trailingPriority)
        }
        if let top=top{
            let topConstraint = firstView.topAnchor.constraint(equalTo: secondView.topAnchor, constant: top)
            activateConstraint(constraint: topConstraint, priority: topPriority)
        }
        if let bottom=bottom{
            let bottomConstraint = firstView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor, constant: bottom)
            activateConstraint(constraint: bottomConstraint, priority: bottomPriority)
        }
        
        
    }
    
    func activateConstraint(constraint:NSLayoutConstraint,
                                   priority:UILayoutPriority? = nil){
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.isActive = true
    }
    
    
    
}
