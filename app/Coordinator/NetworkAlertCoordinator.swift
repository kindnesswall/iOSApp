//
//  NetworkAlertCoordinator.swift
//  app
//
//  Created by Amir Hossein on 3/10/20.
//  Copyright © 2020 Hamed.Gh. All rights reserved.
//

import UIKit

protocol NetworkAlertCoordinator: NavigationCoordinator {
    func showDialogFailed(closeType: NetworkAlertCloseType, tryAgainHandler: @escaping () -> Void)
}

extension NetworkAlertCoordinator {
    func showDialogFailed(closeType: NetworkAlertCloseType, tryAgainHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: LanguageKeys.requestfailDialogTitle.localizedString,
            message: LanguageKeys.requestfailDialogText.localizedString,
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(
            UIAlertAction(
                title: LanguageKeys.tryAgain.localizedString,
                style: UIAlertAction.Style.default, handler: { (_) in
                    tryAgainHandler()
            }))

        if closeType != .none {
            alert.addAction(
            UIAlertAction(
                title: LanguageKeys.closeThisPage.localizedString,
                style: UIAlertAction.Style.default, handler: { [weak self] (_) in
                    if closeType == .dismissPage {
                        self?.navigationController.dismiss(animated: true, completion: nil)
                    }
            }))
        }

        self.navigationController.present(alert, animated: true, completion: nil)
    }
}

enum NetworkAlertCloseType {
    case none
    case dismissAlert
    case dismissPage
}
