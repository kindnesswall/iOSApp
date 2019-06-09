//
//  HomeVM.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeVM: NSObject {
    
    var isAdmin:Bool = true
    
    var giftsSessions:[URLSession?]=[]
    var giftsTasks:[URLSessionDataTask?]=[]
    weak var delegate:HomeViewModelDelegate?

    var gifts:[Gift] = []
    
    var isLoadingGifts=false
    var initialGiftsLoadingHasOccurred=false
    var lazyLoadingCount=20
    
    func reloadPage(){
        if initialGiftsLoadingHasOccurred {
            APICall.stopAndClearRequests(sessions: &giftsSessions, tasks: &giftsTasks)
            isLoadingGifts=false
            getGifts(beforeId: nil)
        }
    }
    
    var categoryId:Int?
    var provinceId:Int?
    
    func handleError(beforeId:Int?) {
        self.delegate?.pageLoadingAnimation(isLoading: false)
        self.delegate?.lazyLoadingAnimation(isLoading: false)
        self.delegate?.refreshControlAnimation(isLoading: false)
        
        let alert = UIAlertController(
            title:LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_title),
            message: LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_text),
            preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { [weak self] (action) in
            self?.isLoadingGifts=false
            self?.getGifts(beforeId:beforeId)
        }))
        
        if self.gifts.count > 0 {
            self.delegate?.showTableView(show: true)
            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: {
                //                        [weak self]
                (action) in
                alert.dismiss(animated: true, completion: {
                    
                })
            }))
        }else{
            self.delegate?.showTableView(show: false)
        }
        
        self.delegate?.presentfailedAlert(alert: alert)
    }
    
    func handleResponse(beforeId:Int?, recieveGifts reply:[Gift]) {
        if beforeId==nil {
            self.gifts=[]
            self.delegate?.showTableView(show: true)
            self.delegate?.reloadTableView()
        }
        
        self.delegate?.pageLoadingAnimation(isLoading: false)
        self.delegate?.lazyLoadingAnimation(isLoading: false)
        self.delegate?.refreshControlAnimation(isLoading: false)
        
        if reply.count == self.lazyLoadingCount {
            self.isLoadingGifts=false
        }
        
        var insertedIndexes=[IndexPath]()
        let firstIndex = self.gifts.count
        
        self.gifts.append(contentsOf: reply)

        let lastIndex = self.gifts.count
        
        for i in firstIndex..<lastIndex{
            insertedIndexes.append(IndexPath(item: i, section: 0))
        }
        
        self.delegate?.insertNewItemsToTableView(insertedIndexes: insertedIndexes)
    }
    
    func getGifts(beforeId:Int?){
        
        self.initialGiftsLoadingHasOccurred=true
        if isLoadingGifts {
            return
        }
        isLoadingGifts=true
        
        if beforeId==nil {
            self.delegate?.pageLoadingAnimation(isLoading: true)
        } else {
            self.delegate?.lazyLoadingAnimation(isLoading: true)
        }
        
        let input = RequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        input.provinceId = self.provinceId
        input.categoryId = self.categoryId
        
        var url:String!
        if isAdmin {
            url = URIs().gifts_review
        }else{
            url = URIs().gifts
        }
        url = URIs().gifts
        APICall.request(url: url, httpMethod: .POST, input: input, sessions: &giftsSessions, tasks: &giftsTasks) { [weak self] (data, response, error) in
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode == APICall.OKStatus else {
                print("Get error register")
                self?.handleError(beforeId: beforeId)
                return
            }
            
            if let reply=ApiUtility.convert(data: data, to: [Gift].self) {
                self?.handleResponse(beforeId:beforeId, recieveGifts:reply)
            }
        }
        
    }
}
