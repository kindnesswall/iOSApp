//
//  ViewController.swift
//  SwiftyOnboardExample
//
//  Created by Jay on 3/27/17.
//  Copyright © 2017 Juan Pablo Fernandez. All rights reserved.
//

import UIKit
import SwiftyOnboard

class IntroViewController: UIViewController {

    var swiftyOnboard: SwiftyOnboard!
    let colors: [UIColor] = [#colorLiteral(red: 0.9980840087, green: 0.3723873496, blue: 0.4952875376, alpha: 1), #colorLiteral(red: 0.2666860223, green: 0.5116362572, blue: 1, alpha: 1), #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    var titleArray: [String] = [
       LanguageKeys.introCulture.localizedString,
       LanguageKeys.introDonatePlatform.localizedString,
       LanguageKeys.introFree.localizedString,
       LanguageKeys.introOpensource.localizedString
    ]

    var subTitleArray2: [String] = [
    "",
    "",
    "",
    ""
        ]
    var subTitleArray: [String] = [
       LanguageKeys.introSubtitleCulture.localizedString,
       LanguageKeys.introSubtitleDonatePlatform.localizedString,
       LanguageKeys.introSubtitleFree.localizedString,
       LanguageKeys.introSubtitleOpensource.localizedString
    ]

    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        gradient()

        swiftyOnboard = SwiftyOnboard(frame: view.frame, style: .light)

        view.addSubview(swiftyOnboard)
        swiftyOnboard.dataSource = self
        swiftyOnboard.delegate = self
    }

    func gradient() {
        //Add the gradiant to the view:
        self.gradiant.frame = view.bounds
        view.layer.addSublayer(gradiant)
    }

    @objc func handleSkip() {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        if index == titleArray.count-1 {
            self.dismiss(animated: true, completion: nil)
        } else {
            swiftyOnboard?.goToPage(index: index + 1, animated: true)
        }
    }
}

extension IntroViewController: SwiftyOnboardDelegate, SwiftyOnboardDataSource {

    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        //Number of pages in the onboarding:
        return titleArray.count
    }

    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        //Return the background color for the page at index:
        return colors[index]
    }

    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = SwiftyOnboardPage()

        //Set the image on the page:
        view.imageView.image = UIImage(named: AppImages.Intro + "\(index)")

        //Set the font and color for the labels:
        view.title.font = AppConst.Resource.Font.getBoldFont(size: 22)
        view.subTitle.font = AppConst.Resource.Font.getRegularFont(size: 14)

        //Set the text in the page:
        view.title.text = titleArray[index]
        view.subTitle.text = subTitleArray[index]

        //Return the page for the given index:
        return view
    }

    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()

        //Setup targets for the buttons on the overlay view:
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)

        //Setup for the overlay buttons:
        overlay.continueButton.titleLabel?.font = AppConst.Resource.Font.getBoldFont(size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = AppConst.Resource.Font.getRegularFont(size: 16)

        overlay.continueButton.setTitle(
           LanguageKeys.yes.localizedString,
            for: .normal)

        overlay.skipButton.setTitle(
           LanguageKeys.skip.localizedString, for: .normal)

        //Return the overlay view:
        return overlay
    }

    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)

        if Int(currentPage) < titleArray.count-1 {
            overlay.continueButton.setTitle(
               LanguageKeys.yes.localizedString,
                for: .normal)

            overlay.skipButton.setTitle(
               LanguageKeys.skip.localizedString, for: .normal)

            overlay.skipButton.show()
        } else {
            overlay.continueButton.setTitle(LanguageKeys.letsGoToTheApplication.localizedString, for: .normal)
            overlay.skipButton.hide()
        }
    }
}
