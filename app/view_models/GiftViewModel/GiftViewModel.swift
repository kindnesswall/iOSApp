//
//  GiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit


class GiftViewModel: NSObject {
    
    let url:String
    var gifts=[Gift]()
    
    weak var delegate : GiftViewModelDelegate?
    
    var giftsSessions:[URLSession?]=[]
    var giftsTasks:[URLSessionDataTask?]=[]
    
    var isLoadingGifts_ForLazyLoading=false
    var initialGiftsLoadingHasOccurred=false
    var isLoadingGifts=false
    
    var lazyLoadingCount=20
    
    init(url:String) {
        self.url = url
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
        
        
        let input=RequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        isLoadingGifts = true
        
        APICall.request(url: url, httpMethod: .POST, input: input , sessions: &giftsSessions, tasks: &giftsTasks) { [weak self] (data, response, error) in
            
            self?.isLoadingGifts = false
            let response = response as? HTTPURLResponse
            
            print(self?.url)
            print("\(response?.statusCode)")
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
