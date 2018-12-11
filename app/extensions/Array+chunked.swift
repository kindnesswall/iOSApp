//
//  Array+chunked.swift
//  app
//
//  Created by Hamed.Gh on 12/11/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
