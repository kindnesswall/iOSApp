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

   
   
   
    func getGifts(index:Int){
        
        self.initialGiftsLoadingHasOccurred=true
        
        if isLoadingGifts_ForLazyLoading {
            return
        }
        isLoadingGifts_ForLazyLoading=true
        
        if index==0 {
            self.delegate?.pageLoadingAnimation(viewModel:self,isLoading: true)
        } else {
            self.delegate?.lazyLoadingAnimation(viewModel:self,isLoading: true)
        }
        
        guard let userId=KeychainSwift().get(AppConst.KeyChain.USER_ID) else {
            return
        }
        let url=APIURLs.getMyRegisteredGifts+"/"+userId+"/\(index)/\(index+lazyLoadingCount)"
        
        let input:APIEmptyInput?=nil
        
        isLoadingGifts = true
        APICall.request(url: url, httpMethod: .GET, input: input , sessions: &giftsSessions, tasks: &giftsTasks) { [weak self] (data, response, error) in
            
            self?.isLoadingGifts = false
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
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
            getGifts(index: 0)
        }
        
    }
}
