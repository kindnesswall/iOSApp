//
//  CategoryListVM.swift
//  app
//
//  Created by AmirHossein on 2/9/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class CategoryListVM: NSObject {
    
    let apiMethod=ApiMethods()
    
    var categories=[Category]()
    
    init(hasDefaultOption:Bool,completionHandler:(()->Void)?) {
        super.init()
        
        getCategories(hasDefaultOption: hasDefaultOption,completionHandler: completionHandler)
    }

    func getCategories(hasDefaultOption:Bool,completionHandler:(()->Void)?){
        apiMethod.getCategories { [weak self] (data, response, error) in
            if let reply=ApiUtility.convert(data: data, to: [Category].self) {
                self?.categories=[]
                if hasDefaultOption {
                    let defaultOption=Category(id: "0", title: LocalizationSystem.getStr(forKey: LanguageKeys.allGifts))
                    self?.categories.append(defaultOption)
                }
                self?.categories.append(contentsOf: reply)
                completionHandler?()
            }
        }
    }
    
    func setCell(cell:CategoryOptionsTableViewCell,indexPath:IndexPath) {
        cell.setValue(category: categories[indexPath.row])
    }
    
    func returnCellData(indexPath:IndexPath)->Category {
        return categories[indexPath.row]
    }
}