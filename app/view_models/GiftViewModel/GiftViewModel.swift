//
//  GiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit


class GiftViewModel: NSObject {

    var gifts=[Gift]()
    
    weak var delegate : GiftViewModelDelegate?
    
    var giftsSessions:[URLSession?]=[]
    var giftsTasks:[URLSessionDataTask?]=[]
    
    var isLoadingGifts_ForLazyLoading=false
    var initialGiftsLoadingHasOccurred=false
    var isLoadingGifts=false
    
    var lazyLoadingCount=20
    
}

protocol GiftViewModelDelegate: class {
    func pageLoadingAnimation(viewModel:GiftViewModel,isLoading:Bool)
    func lazyLoadingAnimation(viewModel:GiftViewModel,isLoading:Bool)
    func refreshControlAnimation(viewModel:GiftViewModel,isLoading:Bool)
    func showTableView(viewModel:GiftViewModel,show:Bool)
    func reloadTableView(viewModel:GiftViewModel)
    func insertNewItemsToTableView(viewModel:GiftViewModel,insertedIndexes:[IndexPath])
    func presentfailedAlert(viewModel:GiftViewModel,alert:UIAlertController)
}
