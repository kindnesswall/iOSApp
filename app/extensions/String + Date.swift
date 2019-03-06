//
//  String + Date.swift
//  app
//
//  Created by Amir Hossein on 3/5/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import Foundation

extension String {
    func getGregorianDate()->String?{
        guard let dateString = self.components(separatedBy: "T").first else {
            return nil
        }
        return dateString
    }
}
