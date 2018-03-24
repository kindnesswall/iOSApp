//
//  CategoryListViewModel.swift
//  app
//
//  Created by AmirHossein on 2/9/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class CategoryListViewModel: NSObject {
    
    let apiMethod=ApiMethods()
    
    var categories=[Category]()
    
    init(hasDefaultOption:Bool,completionHandler:(()->Void)?) {
        super.init()
        
        getCategories(hasDefaultOption: hasDefaultOption,completionHandler: completionHandler)
    }

    func getCategories(hasDefaultOption:Bool,completionHandler:(()->Void)?){
        apiMethod.getCategories { (data, response, error) in
            if let reply=APIRequest.readJsonData(data: data, outputType: [Category].self) {
                self.categories=[]
                if hasDefaultOption {
                    let defaultOption=Category(id: "0", title: "همه هدیه‌ها")
                    self.categories.append(defaultOption)
                }
                self.categories.append(contentsOf: reply)
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
