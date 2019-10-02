//
//  GiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit


class GiftViewModel: NSObject {
    
    let giftListType:GiftListType
    var gifts=[Gift]()
    
    weak var delegate : GiftViewModelDelegate?
    
    var isLoadingGifts_ForLazyLoading=false
    var initialGiftsLoadingHasOccurred=false
    var isLoadingGifts=false
    
    var lazyLoadingCount=20
    
    lazy var httpLayer = HTTPLayer()
    lazy var apiRequest = ApiRequest(httpLayer)
    
    init(giftListType:GiftListType) {
        self.giftListType = giftListType
    }
    
    func handleGetGift(_ result:Result<[Gift]>,_ beforeId:Int?) {
        
        switch result {
        case .failure(let error):
            print(error)
        case .success(let gifts):
            self.isLoadingGifts = false
            if beforeId==nil {
                self.gifts=[]
                self.delegate?.reloadTableView(viewModel:self)
                
            }
            self.delegate?.refreshControlAnimation(viewModel:self,isLoading: false)
        
            self.delegate?.pageLoadingAnimation(viewModel:self,isLoading: false)
        
            self.delegate?.lazyLoadingAnimation(viewModel:self,isLoading: false)
            
            if gifts.count == self.lazyLoadingCount {
                self.isLoadingGifts_ForLazyLoading=false
            }
            
            var insertedIndexes=[IndexPath]()
            let minCount = self.gifts.count
            for i in minCount..<minCount+gifts.count {
                insertedIndexes.append(IndexPath(item: i, section: 0))
            }
            
            self.gifts.append(contentsOf: gifts)
            
            self.delegate?.insertNewItemsToTableView(viewModel:self,insertedIndexes: insertedIndexes)
            
        }
        
    }
    
    func getGifts(beforeId:Int?){
        
        self.initialGiftsLoadingHasOccurred=true
        
        if isLoadingGifts_ForLazyLoading {
            return
        }
        isLoadingGifts_ForLazyLoading=true
        
        if beforeId==nil {
            self.delegate?.pageLoadingAnimation(viewModel:self,isLoading: true)
        } else {
            self.delegate?.lazyLoadingAnimation(viewModel:self,isLoading: true)
        }
        
        let input=GiftsRequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        isLoadingGifts = true
        
        var endPoint:Endpoint!
        switch giftListType {
        case .GiftsToDonate(let toUserId):
            endPoint = Endpoint.GiftsToDonate(toUserId: toUserId, input: input)
        case .UserDonatedGifts(let userId):
            endPoint = Endpoint.UserDonatedGifts(userId: userId, input: input)
        case .UserReceivedGifts(let userId):
            endPoint = Endpoint.UserReceivedGifts(userId: userId, input: input)
        case .UserRegisteredGifts(let userId):
            endPoint = Endpoint.UserRegisteredGifts(userId: userId, input: input)
        }
        
        apiRequest.getGifts(endPoint:endPoint) { [weak self] (result) in
            
            DispatchQueue.main.async {
                self?.handleGetGift(result, beforeId)
            }
        }
        
    }
    
    func reloadGifts(){
        if self.initialGiftsLoadingHasOccurred {
            self.httpLayer.cancelRequests()
            isLoadingGifts_ForLazyLoading=false
            getGifts(beforeId: nil)
        }
    }
    
}

extension GiftViewModel : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell=tableView.dequeueReusableCell(withIdentifier: GiftTableViewCell.identifier, for: indexPath) as! GiftTableViewCell
        
        cell.filViews(gift: gifts[indexPath.row])
        
        let index=indexPath.row+1
        if index==self.gifts.count {
            if !self.isLoadingGifts_ForLazyLoading {
                if let beforeId = self.gifts[indexPath.row].id {
                    getGifts(beforeId: beforeId)
                }
            }
        }
        return cell
    }
    
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
