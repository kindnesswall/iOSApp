//
//  RGVC+IBAction.swift
//  app
//
//  Created by Hamed.Gh on 12/30/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension RegisterGiftViewController {

    @IBAction func submitBtnAction(_ sender: Any) {

        self.registerBtn.isEnabled=false

        vm.registerGift { (result) in
            DispatchQueue.main.async {
                self.registerBtn.isEnabled=true
                self.handleRegisterGift(result)
            }
        }
    }

    func handleRegisterGift(_ result: Result<Gift>) {
        switch result {
        case .failure(let error):
            switch error {
            case .clientSide(let message):
                FlashMessage.showMessage(body: message, theme: .warning)
            default:
                FlashMessage.showMessage(body: LanguageKeys.weEncounterErrorTryAgain.localizedString, theme: .error)
            }
        case .success:
            FlashMessage.showMessage(body: LanguageKeys.giftRegisteredSuccessfully.localizedString, theme: .success)

            self.clearAllInput()
            self.reloadOtherPages()
        }
    }

    @IBAction func editBtnAction(_ sender: Any) {
        self.editBtn.isEnabled=false
        vm.editGift { (result) in
            DispatchQueue.main.async {
                self.editBtn.isEnabled=true
                self.handleEditGift(result)
            }
        }
    }

    func handleEditGift(_ result: Result<Gift>) {
        switch result {
        case .failure:
            FlashMessage.showMessage(body: LanguageKeys.weEncounterErrorTryAgain.localizedString, theme: .error)
        case .success:
            FlashMessage.showMessage(body: LanguageKeys.giftEditedSuccessfully.localizedString, theme: .success)

            self.vm.writeChangesToEditedGift()
            self.editHandler?()

            let when=DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    @IBAction func placeBtnAction(_ sender: Any) {

        self.clearGiftPlaces()
        self.vm.giftHasNewAddress=true
        self.configAddressViews()

        let controller=OptionsListViewController()
        let viewModel = PlaceListViewModel(placeType: .province, showCities: true, showRegions: false, hasDefaultOption: false)
        controller.viewModel=viewModel
        controller.completionHandler= { [weak self] (id, name) in
            let place=Place(id: id, name: name)
            self?.vm.places.append(place)
            self?.addGiftPlace(place: place)
        }
        controller.closeHandler= { [weak self] in
            self?.clearGiftPlaces()
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }

    @IBAction func categoryBtnClicked(_ sender: Any) {

        let controller=OptionsListViewController()
        let viewModel = CategoryListVM(hasDefaultOption: false)
        controller.viewModel=viewModel
        controller.completionHandler= { [weak self] (id, name) in
            self?.categoryBtn.setTitle(name, for: .normal)
            self?.vm.category=Category(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }

    @IBAction func dateStatusBtnAction(_ sender: Any) {
        let controller=OptionsListViewController()
        let viewModel = DateStatusListViewModel()
        controller.viewModel=viewModel
        controller.completionHandler= { [weak self] (id, name) in
            self?.dateStatusBtn.setTitle(name, for: .normal)
            self?.vm.dateStatus=DateStatus(id: id, title: name)
        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)
    }
}
