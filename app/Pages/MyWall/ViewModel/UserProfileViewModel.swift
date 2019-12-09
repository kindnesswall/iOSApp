//
//  UserProfileViewModel.swift
//  app
//
//  Created by Amir Hossein on 12/7/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class UserProfileViewModel: NSObject {

    lazy var httpLayer = HTTPLayer()
    lazy var apiService = ApiService(httpLayer)
    let userId: Int

    @BindingWrapper var profile: UserProfile?
    @BindingWrapper var loadingState: ViewLoadingState = .loading(.initial)

    init(userId: Int) {
        self.userId = userId
    }

    func getProfile(loadingType: ViewLoadingType) {
        loadingState = .loading(loadingType)
        apiService.getUserProfile(userId: userId) {[weak self] result in
            switch result {
            case .success(let profile):
                self?.profile = profile
                self?.loadingState = .success
            case .failure(let error):
                self?.loadingState = .failed(error)
            }
        }
    }
}
