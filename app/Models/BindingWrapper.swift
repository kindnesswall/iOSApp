//
//  BindingWrapper.swift
//  app
//
//  Created by Amir Hossein on 12/7/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

@propertyWrapper
class BindingWrapper<T> {
    var wrappedValue: T {didSet {bind?(wrappedValue)}}
    var projectedValue: BindingWrapper<T> { return self }
    var bind: ((T)->Void)?
    
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }
}
