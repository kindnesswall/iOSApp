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
    
    init(completionHandler:(()->Void)?) {
        super.init()
        
        getCategories(completionHandler: completionHandler)
    }

    func getCategories(completionHandler:(()->Void)?){
        apiMethod.getCategories { (data, response, error) in
            if let reply=APIRequest.readJsonData(data: data, outputType: [Category].self) {
                self.categories=[]
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
