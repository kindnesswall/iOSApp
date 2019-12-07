//
//  CategoryListVM.swift
//  app
//
//  Created by AmirHossein on 2/9/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class CategoryListVM: NSObject, OptionsListViewModelProtocol {
    
    let titleName:String
    let hasDefaultOption:Bool
    var categories=[Category]()
    lazy var apiService = ApiService(HTTPLayer())
    
    func getElementsCount()->Int{
        return self.categories.count
    }
    
    init(hasDefaultOption:Bool) {
        self.titleName = LanguageKeys.category.localizedString
        self.hasDefaultOption=hasDefaultOption
        super.init()
    }

    func fetchElements(completionHandler:(()->Void)?){
        apiService.getCategories { [weak self](result) in
            switch result{
            case .failure(let appError):
                print(appError)
            case .success(let categories):
                self?.categories=[]
                if self?.hasDefaultOption ?? false {
                    let defaultOption=Category(id: nil, title: LanguageKeys.allGifts.localizedString)
                    self?.categories.append(defaultOption)
                }
                self?.categories.append(contentsOf: categories)
                DispatchQueue.main.async {
                    completionHandler?()
                }
            }
        }
    }
    
    func registerCell(tableView:UITableView){
        tableView.register(type: CategoryOptionsTableViewCell.self)
    }
    
    func dequeueReusableCell(tableView:UITableView,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeue(type: CategoryOptionsTableViewCell.self, for: indexPath)
        cell.setValue(category: categories[indexPath.row])
        return cell
    }
   
    
    func returnCellData(indexPath:IndexPath)->(Int?,String?) {
        return (categories[indexPath.row].id,categories[indexPath.row].title)
    }
    
    func getNestedViewModel(indexPath:IndexPath)->OptionsListViewModelProtocol? {
        return nil
    }
}
