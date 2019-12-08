//
//  ProfileViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 19.05.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit

class ProfileViewModel: UploadImageVM {

    var username: String?

    override init() {

    }

    func uploadThe(image: UIImage, onSuccess:@escaping () -> Void, onFail:(() -> Void)?) {

        self.upload(image: image, onSuccess: { [weak self] in
            self?.updateUser(name: self?.username, completion: { (result) in
                switch result {
                case .failure:
                    onFail?()
                case .success:
                    onSuccess()
                }
            })
        }, onFail: onFail)

    }

    func updateUser(name: String?, completion: @escaping (Result<Void>) -> Void) {
        let profile = UserProfile.Input(name: name, image: imageUrl)
        apiService.updateUser(profile: profile) { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success:
                completion(.success(Void()))
            }
        }
    }

    func getProfile(completion: @escaping (Result<UserProfile>) -> Void) {
        if let userId = KeychainService().get(.userId), let id = Int(userId) {
            apiService.getUserProfile(userId: id) { [weak self](result) in
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let userProfile):
                    self?.imageUrl = userProfile.image
                    self?.username = userProfile.name
                    completion(.success(userProfile))
                }
            }
        }
    }

}
