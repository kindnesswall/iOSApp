//
//  DateStatusListViewModel.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class DateStatusListViewModel: NSObject {

    var dateStatus=[DateStatus]()
    
    override init() {
        super.init()
        
        dateStatus.append(DateStatus(id:"0",title:LocalizationSystem.getStr(forKey: LanguageKeys.new)))
        dateStatus.append(DateStatus(id: "1" , title: LocalizationSystem.getStr(forKey: LanguageKeys.used)))
    }
    
    func setCell(cell:GenericOptionsTableViewCell,indexPath:IndexPath) {
        cell.setValue(name: dateStatus[indexPath.row].title)
    }
    func returnCellData(indexPath:IndexPath)->DateStatus {
        return dateStatus[indexPath.row]
    }
    
}
