//
//  MyWallTableViewSegment.swift
//  app
//
//  Created by Amir Hossein on 11/20/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class MyWallTableViewSegment: UIView {

    var tableViewCellHeight: CGFloat=122
    @IBOutlet weak var tableView: UITableView!
    var initialLoadingIndicator: LoadingIndicator?
    var lazyLoadingIndicator: LoadingIndicator?
    var refreshControl=UIRefreshControl()
    var viewModel: GiftViewModel?
    @IBOutlet weak var emptyListLabel: UILabel!
    var emptyListMessage: String?
    var presentDetailPage: ((Gift) -> Void)?

    enum LoadingType {
        case initial
        case lazy
    }

    override func awakeFromNib() {
        configTableView()
        configRefreshControl()
        configLoadingAnimations()
        self.tableView.delegate = self

    }

    func setViewModel(viewModel: GiftViewModel?) {
        self.viewModel = viewModel

        self.viewModel?.delegate = self
        self.tableView.dataSource = self.viewModel
    }

    func configTableView() {
        tableView.register(type: GiftTableViewCell.self)
        tableView.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)
    }

    func configRefreshControl() {
        configRefreshControl(refreshControl: refreshControl, tableView: tableView, action: #selector(self.refreshControlAction))
    }

    func configRefreshControl(refreshControl: UIRefreshControl, tableView: UITableView, action: Selector) {
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        refreshControl.tintColor=AppConst.Resource.Color.Tint
        tableView.addSubview(refreshControl)
    }

    func configLoadingAnimations() {
        self.initialLoadingIndicator=LoadingIndicator(view: self)

        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self, cellHeight: tableViewCellHeight/2)
    }

    func setTableViewLoading(isLoading: Bool, loadingType: LoadingType) {

        let loadingIndicator: LoadingIndicator?

        switch loadingType {
        case .initial:
            loadingIndicator=initialLoadingIndicator
        case .lazy:
            loadingIndicator=lazyLoadingIndicator
        }

        if isLoading {
            loadingIndicator?.startLoading()
        } else {
            loadingIndicator?.stopLoading()
        }
    }

    @objc func refreshControlAction() {
        viewModel?.reloadGifts()
        self.setTableViewLoading(isLoading: false, loadingType: .initial)
    }

    func hideOrShowEmptyListLabel() {

        guard let viewModel = viewModel else { return }

        let count = viewModel.gifts.count
        let isLoading = viewModel.isLoadingGifts

        let show = (count == 0) && (!isLoading)

        if show {
            self.emptyListLabel.text = emptyListMessage
            self.emptyListLabel.show()
        } else {
            self.emptyListLabel.hide()
        }

    }

}

extension MyWallTableViewSegment: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let gift = viewModel?.gifts[indexPath.row] else {
            return
        }

        presentDetailPage?(gift)
    }
}

extension MyWallTableViewSegment: GiftViewModelDelegate {
    func pageLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {

        setTableViewLoading(isLoading: isLoading, loadingType: .initial)

    }

    func lazyLoadingAnimation(viewModel: GiftViewModel, isLoading: Bool) {

        setTableViewLoading(isLoading: isLoading, loadingType: .lazy)

    }

    func refreshControlAnimation(viewModel: GiftViewModel, isLoading: Bool) {

        if isLoading {
        } else {
            self.refreshControl.endRefreshing()
        }
    }

    func showTableView(viewModel: GiftViewModel, show: Bool) {
        tableView.isHidden = !show
    }

    func reloadTableView(viewModel: GiftViewModel) {

        hideOrShowEmptyListLabel()

        tableView.reloadData()
    }

    func insertNewItemsToTableView(viewModel: GiftViewModel, insertedIndexes: [IndexPath]) {

        hideOrShowEmptyListLabel()

        UIView.performWithoutAnimation {
            tableView.insertRows(at: insertedIndexes, with: .bottom)
        }

    }

    func presentfailedAlert(viewModel: GiftViewModel, alert: UIAlertController) {

    }

}
