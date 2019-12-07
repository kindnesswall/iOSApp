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
    
    @BindingWrapper var profile: UserProfile? = nil
    var profileBinding: BindingWrapper<UserProfile?> {
        return _profile
    }
    
    init(userId: Int) {
        self.userId = userId
    }
    
    func getProfile() {
        apiService.getUserProfile(userId: userId) { result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self.profile = profile
                }
            case .failure(let error):
                break
            }
        }
    }
}
