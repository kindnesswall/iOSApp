//
//  HomeViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    
    let apiMethods=ApiMethods()
    weak var delegate:HomeViewModelDelegate?

    var gifts:[Gift] = []
    
    var isLoadingGifts=false
    var initialGiftsLoadingHasOccurred=false
    var lazyLoadingCount=20
    
    func reloadPage(){
        if initialGiftsLoadingHasOccurred {
            apiMethods.clearAllTasksAndSessions()
            isLoadingGifts=false
            getGifts(index:0)
        }
    }
    
    var categoryId="0"
    var cityId="0"
    
    func getGifts(index:Int){
        
        self.initialGiftsLoadingHasOccurred=true
        
        if isLoadingGifts {
            return
        }
        isLoadingGifts=true
        
        if index==0 {
            self.delegate?.pageLoadingAnimation(isLoading: true)
            
        } else {
            self.delegate?.lazyLoadingAnimation(isLoading: true)
        }
        
        apiMethods.getGifts(cityId: self.cityId, regionId: "0", categoryId: self.categoryId, startIndex: index,lastIndex: index+lazyLoadingCount, searchText: "") { [weak self] (data, response, error) in
            //            APIRequest.logReply(data: data)
            
            guard error == nil, let response = response as? HTTPURLResponse, response.statusCode>=200,response.statusCode<300 else {
                print("Get error register")
                
                
                self?.delegate?.pageLoadingAnimation(isLoading: false)
                self?.delegate?.lazyLoadingAnimation(isLoading: false)
                self?.delegate?.refreshControlAnimation(isLoading: false)
                
                
                let alert = UIAlertController(
                    title:LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_title),
                    message: LocalizationSystem.getStr(forKey: LanguageKeys.requestfail_dialog_text),
                    preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { [weak self] (action) in
                    self?.isLoadingGifts=false
                    self?.getGifts(index:index)
                }))
                
                if let gifts = self?.gifts, gifts.count > 0 {
                    self?.delegate?.showTableView(show: true)
                    alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: {
//                        [weak self]
                        (action) in
                        alert.dismiss(animated: true, completion: {
                            
                        })
                    }))
                }else{
                    self?.delegate?.showTableView(show: false)
                }
                
                self?.delegate?.presentfailedAlert(alert: alert)
                
                return
            }
            
            if let reply=APIRequest.readJsonData(data: data, outputType: [Gift].self) {
                
                if index==0 {
                    self?.gifts=[]
                    self?.delegate?.showTableView(show: true)
                    self?.delegate?.reloadTableView()
                }
                
                self?.delegate?.pageLoadingAnimation(isLoading: false)
                self?.delegate?.lazyLoadingAnimation(isLoading: false)
                self?.delegate?.refreshControlAnimation(isLoading: false)
                
                if reply.count == self?.lazyLoadingCount {
                    self?.isLoadingGifts=false
                }
                
                var insertedIndexes=[IndexPath]()
                let firstIndex = self?.gifts.count
                
                let chunkedGifts = reply.chunked(into: 10)
                for chunk in chunkedGifts {
                    let ad = Gift()
                    ad.isAd = true
                    self?.gifts.append(ad)
                    self?.gifts.append(contentsOf: chunk)
                }
                if let firstIndex = firstIndex, let lastIndex = self?.gifts.count {
                    for i in firstIndex..<lastIndex{
                        insertedIndexes.append(IndexPath(item: i, section: 0))
                    }
                }
               
                self?.delegate?.insertToTableView(insertedIndexes: insertedIndexes)
                
            
            }
            
        }
    }
}

protocol HomeViewModelDelegate: class {
    func pageLoadingAnimation(isLoading:Bool)
    func lazyLoadingAnimation(isLoading:Bool)
    func refreshControlAnimation(isLoading:Bool)
    func showTableView(show:Bool)
    func reloadTableView()
    func insertToTableView(insertedIndexes:[IndexPath])
    func presentfailedAlert(alert:UIAlertController)
}
