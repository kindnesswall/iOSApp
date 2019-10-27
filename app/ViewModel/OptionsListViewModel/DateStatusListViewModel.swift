//
//  DateStatusListViewModel.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class DateStatusListViewModel: NSObject, OptionsListViewModelProtocol {
    
    let titleName:String
    
    var dateStatus=[DateStatus]()
    
    func getElementsCount()->Int{
        return self.dateStatus.count
    }
    
    override init() {
        
        self.titleName = LanguageKeys.newOrUsed.localizedString
       
        super.init()
        
    }
    
    func fetchElements(completionHandler:(()->Void)?){
        dateStatus.append(DateStatus(id:0,title:LanguageKeys.new.localizedString))
        dateStatus.append(DateStatus(id: 1 , title: LanguageKeys.used.localizedString))
        completionHandler?()
    }
    
    func registerCell(tableView:UITableView){
        tableView.register(type: GenericOptionsTableViewCell.self)
    }
    
    func dequeueReusableCell(tableView:UITableView,indexPath:IndexPath)->UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericOptionsTableViewCell.identifier, for: indexPath) as! GenericOptionsTableViewCell
        cell.setValue(name: dateStatus[indexPath.row].title)
        return cell
    }
    
    func returnCellData(indexPath:IndexPath)->(Int?,String?) {
        return (dateStatus[indexPath.row].id,dateStatus[indexPath.row].title)
    }
    
    func getNestedViewModel(indexPath:IndexPath)->OptionsListViewModelProtocol? {
        return nil
    }
    
}
