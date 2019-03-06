//
//  RegisteredGiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class RegisteredGiftViewModel: GiftViewModel {

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
        
        let url=URIs().gifts_owner
        
        let input=RequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        
        isLoadingGifts = true
        APICall.request(url: url, httpMethod: .POST, input: input , sessions: &giftsSessions, tasks: &giftsTasks) { [weak self] (data, response, error) in
            
            self?.isLoadingGifts = false
            
            if let reply=ApiUtility.convert(data: data, to: [Gift].self) {
                
                if beforeId==nil {
                    self?.gifts=[]
                    if let strongSelf = self {
                        self?.delegate?.reloadTableView(viewModel:strongSelf)
                    }
                }
                
                if let strongSelf = self {
                    self?.delegate?.refreshControlAnimation(viewModel:strongSelf,isLoading: false)
                    self?.delegate?.pageLoadingAnimation(viewModel:strongSelf,isLoading: false)
                    self?.delegate?.lazyLoadingAnimation(viewModel:strongSelf,isLoading: false)
                }
                
                
                
                if reply.count == self?.lazyLoadingCount {
                    self?.isLoadingGifts_ForLazyLoading=false
                }
                
                var insertedIndexes=[IndexPath]()
                if let minCount = self?.gifts.count {
                    for i in minCount..<minCount+reply.count {
                        insertedIndexes.append(IndexPath(item: i, section: 0))
                    }
                }
                
                self?.gifts.append(contentsOf: reply)
                
                
                //                self?.showMessage()
                
                if let strongSelf = self {
                    self?.delegate?.insertNewItemsToTableView(viewModel:strongSelf,insertedIndexes: insertedIndexes)
                }
                
            }
        }
        
    }
    
    func reloadGifts(){
        
        if self.initialGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &giftsSessions, tasks: &giftsTasks)
            isLoadingGifts_ForLazyLoading=false
            getGifts(beforeId: nil)
        }
        
    }
}
