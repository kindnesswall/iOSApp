//
//  HomeViewModelDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

protocol HomeViewModelDelegate: class {
    func pageLoadingAnimation(isLoading:Bool)
    func lazyLoadingAnimation(isLoading:Bool)
    func refreshControlAnimation(isLoading:Bool)
    func showTableView(show:Bool)
    func reloadTableView()
    func insertNewItemsToTableView(insertedIndexes:[IndexPath])
    func presentfailedAlert(alert:UIAlertController)
}

