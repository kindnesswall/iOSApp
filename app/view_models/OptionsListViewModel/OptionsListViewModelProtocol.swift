//
//  OptionsListViewModelProtocol.swift
//  app
//
//  Created by Amir Hossein on 3/3/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

protocol OptionsListViewModelProtocol {
    
    var titleName:String { get }
    
    func getElementsCount()->Int
    
    func fetchElements(completionHandler:(()->Void)?)
    
    func registerCell(tableView:UITableView)
    
    func dequeueReusableCell(tableView:UITableView,indexPath:IndexPath)->UITableViewCell
    func returnCellData(indexPath:IndexPath)->(Int?,String?)
    
    func getNestedViewModel(indexPath:IndexPath)->OptionsListViewModelProtocol?
}
