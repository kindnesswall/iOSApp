//
//  GiftViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/19/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class GiftViewModel: NSObject {

    let giftListType: GiftListType
    var gifts=[Gift]()

    weak var delegate: GiftViewModelDelegate?

    var isLoadingGiftsForLazyLoading=false
    @BindingWrapper var hasLazyLoadingFinished = false
    var initialGiftsLoadingHasOccurred=false
    var isLoadingGifts=false

    var lazyLoadingCount=20

    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)

    init(giftListType: GiftListType) {
        self.giftListType = giftListType
    }

    func handleGetGift(_ result: Result<[Gift]>, _ beforeId: Int?) {

        switch result {
        case .failure(let error):
            print(error)
        case .success(let gifts):
            self.isLoadingGifts = false
            if beforeId==nil {
                self.gifts=[]
                self.delegate?.reloadTableView(viewModel: self)

            }
            self.delegate?.refreshControlAnimation(viewModel: self, isLoading: false)

            self.delegate?.pageLoadingAnimation(viewModel: self, isLoading: false)

            self.delegate?.lazyLoadingAnimation(viewModel: self, isLoading: false)

            if gifts.count == self.lazyLoadingCount {
                self.isLoadingGiftsForLazyLoading=false
            } else {
                self.hasLazyLoadingFinished = true
            }

            var insertedIndexes=[IndexPath]()
            let minCount = self.gifts.count
            for counter in minCount..<minCount+gifts.count {
                insertedIndexes.append(IndexPath(item: counter, section: 0))
            }

            self.gifts.append(contentsOf: gifts)

            self.delegate?.insertNewItemsToTableView(viewModel: self, insertedIndexes: insertedIndexes)

        }

    }

    func getGifts(beforeId: Int?) {

        self.initialGiftsLoadingHasOccurred=true

        if isLoadingGiftsForLazyLoading {
            return
        }
        isLoadingGiftsForLazyLoading=true

        if beforeId==nil {
            self.delegate?.pageLoadingAnimation(viewModel: self, isLoading: true)
        } else {
            self.delegate?.lazyLoadingAnimation(viewModel: self, isLoading: true)
        }

        let input=GiftsRequestInput()
        input.beforeId = beforeId
        input.count = self.lazyLoadingCount
        isLoadingGifts = true

        var endPoint: Endpoint!
        switch giftListType {
        case .giftsToDonate(let toUserId):
            endPoint = Endpoint.giftsToDonate(toUserId: toUserId, input: input)
        case .userDonatedGifts(let userId):
            endPoint = Endpoint.userDonatedGifts(userId: userId, input: input)
        case .userReceivedGifts(let userId):
            endPoint = Endpoint.userReceivedGifts(userId: userId, input: input)
        case .userRegisteredGifts(let userId):
            endPoint = Endpoint.userRegisteredGifts(userId: userId, input: input)
        }

        apiService.getGifts(endPoint: endPoint) { [weak self] (result) in

            DispatchQueue.main.async {
                self?.handleGetGift(result, beforeId)
            }
        }

    }

    func reloadGifts() {
        if self.initialGiftsLoadingHasOccurred {
            self.httpLayer.cancelRequests()
            isLoadingGiftsForLazyLoading = false
            hasLazyLoadingFinished = false
            getGifts(beforeId: nil)
        }
    }

}

extension GiftViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.gifts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeue(type: GiftTableViewCell.self, for: indexPath)
        cell.filViews(gift: gifts[indexPath.row])

        let index=indexPath.row+1
        if index==self.gifts.count {
            if !self.isLoadingGiftsForLazyLoading {
                if let beforeId = self.gifts[indexPath.row].id {
                    getGifts(beforeId: beforeId)
                }
            }
        }
        return cell
    }

}

protocol GiftViewModelDelegate: class {
    func pageLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool)
    func lazyLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool)
    func refreshControlAnimation(viewModel: GiftViewModel, isLoading: Bool)
    func showTableView(viewModel: GiftViewModel, show: Bool)
    func reloadTableView(viewModel: GiftViewModel)
    func insertNewItemsToTableView(viewModel: GiftViewModel, insertedIndexes: [IndexPath])
    func presentfailedAlert(viewModel: GiftViewModel, alert: UIAlertController)
}
