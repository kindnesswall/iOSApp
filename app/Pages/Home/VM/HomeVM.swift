//
//  HomeVM.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class HomeVM: NSObject {

    weak var delegate: HomeViewModelDelegate?
    var gifts: [Gift] = []
    var isReview: Bool

    var isLoadingGifts=false
    var initialGiftsLoadingHasOccurred=false
    @BindingWrapper var hasLazyLoadingFinished = false
    var lazyLoadingCount=20

    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)

    var categoryId: Int?
    var provinceId: Int?

    init(isReview: Bool = false) {
        self.isReview = isReview
    }

    func reloadPage() {
        if initialGiftsLoadingHasOccurred {
            httpLayer.cancelRequests()
            isLoadingGifts=false
            hasLazyLoadingFinished = false
            getGifts(beforeId: nil)
        }
    }

    func getEmptyListMessage() -> String {
        return "No gift is available!"
    }

    func giftApprovedAfterReview(rowNumber: Int, completion: @escaping (Result<Void>) -> Void) {
        defer {
            gifts.remove(at: rowNumber)
        }
        guard let giftId = gifts[rowNumber].id else {
            return
        }
        apiService.giftApprovedAfterReview(giftId: giftId) { (result) in
            completion(result)
        }
    }

    func giftRejectedAfterReview(rowNumber: Int, completion: @escaping (Result<Void>) -> Void) {

        guard let giftId = gifts[rowNumber].id else {
            return
        }
        apiService.giftRejectedAfterReview(giftId: giftId) { [weak self](result) in
            switch result {
            case.failure(let error):
                print(error)
            case.success:
                self?.gifts.remove(at: rowNumber)
            }
            completion(result)
        }
    }

    func handleError(beforeId: Int?) {
        self.delegate?.pageLoadingAnimation(isLoading: false)
        self.delegate?.lazyLoadingAnimation(isLoading: false)
        self.delegate?.refreshControlAnimation(isLoading: false)

        let alert = UIAlertController(
            title: LanguageKeys.requestfailDialogTitle.localizedString,
            message: LanguageKeys.requestfailDialogText.localizedString,
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: LanguageKeys.ok.localizedString, style: UIAlertAction.Style.default, handler: { [weak self] _ in
            self?.isLoadingGifts=false
            self?.getGifts(beforeId: beforeId)
        }))

        if self.gifts.count > 0 {
            self.delegate?.showTableView(show: true)
            alert.addAction(UIAlertAction(title: LanguageKeys.cancel.localizedString, style: UIAlertAction.Style.default, handler: { _ in
                alert.dismiss(animated: true, completion: {

                })
            }))
        } else {
            self.delegate?.showTableView(show: false)
        }

        self.delegate?.presentfailedAlert(alert: alert)
    }

    func handleResponse(beforeId: Int?, recieveGifts reply: [Gift]) {
        self.delegate?.pageLoadingAnimation(isLoading: false)
        self.delegate?.lazyLoadingAnimation(isLoading: false)
        self.delegate?.refreshControlAnimation(isLoading: false)

        if beforeId == nil {
            self.gifts=[]
            self.delegate?.reloadTableView()
            
            if reply.count == 0 {
                self.isLoadingGifts=false
                self.delegate?.showTableView(show: false)
                return
            } else {
                self.delegate?.showTableView(show: true)
            }
        }
        
        if reply.count == self.lazyLoadingCount {
            self.isLoadingGifts=false
        } else {
            self.hasLazyLoadingFinished = true
        }

        var insertedIndexes=[IndexPath]()
        let firstIndex = self.gifts.count

        self.gifts.append(contentsOf: reply)

        let lastIndex = self.gifts.count

        for index in firstIndex..<lastIndex {
            insertedIndexes.append(IndexPath(item: index, section: 0))
        }

        self.delegate?.insertNewItemsToTableView(insertedIndexes: insertedIndexes)
    }

    func getGifts(beforeId: Int?) {

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

        let input = GiftsRequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        input.countryId = AppCountry.countryId
        input.provinceId = self.provinceId
        if let categoryId = self.categoryId {
            input.categoryIds = [categoryId]
        }

        var endPoint: Endpoint
        if isReview {
            endPoint = Endpoint.giftsToReview(input: input)
        } else {
            endPoint = Endpoint.getGifts(input: input)
        }

        apiService.getGifts(endPoint: endPoint) { [weak self] (result) in
            DispatchQueue.main.async {
                self?.handleGetGift(result, beforeId)
            }
        }
    }

    func handleGetGift(_ result: Result<[Gift]>, _ beforeId: Int?) {

        switch result {
        case .failure(let error):
            print(error)
            self.handleError(beforeId: beforeId)

        case .success(let gifts):
            self.handleResponse(beforeId: beforeId, recieveGifts: gifts)
        }
    }
}
