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
    let colors:[UIColor] = [#colorLiteral(red: 0.9980840087, green: 0.3723873496, blue: 0.4952875376, alpha: 1),#colorLiteral(red: 0.2666860223, green: 0.5116362572, blue: 1, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1),#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    var titleArray: [String] = [
        "فرهنگ دیوار مهربانی",
        "با همکاری دونیت",
        "همیشه رایگان",
        "متن باز"
    ]
    var subTitleArray2: [String] = [
    "",
    "",
    "",
    ""
        ]
    var subTitleArray: [String] = [
        "نیاز داری، بردار. نیاز نداری، بذار :)",
        "دونِیت یک پلتفرم جذب سرمایه جمعی ایرانی است که در حال حاضر بر روی تامین سرمایه پروژه هایی که تاثیرات اجتماعی دارند، تمرکز کرده است.\n" ,
        "برنامه دیوار مهربانی برای همیشه رایگان خواهد ماند؛ بدون هر گونه تبلیغات.",
        "کدهای برنامه همیشه در دسترس برنامه نویسان خواهد بود."
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gradient()
        UIApplication.shared.statusBarStyle = .lightContent
        
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
//            AppDelegate.me().showTabbar()
            self.dismiss(animated: true, completion: nil)
        }else{
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
        view.imageView.image = UIImage(named: "intro_img_\(index)")
        
        //Set the font and color for the labels:
        view.title.font = AppFont.getBoldFont(size: 22)
        view.subTitle.font = AppFont.getRegularFont(size: 20)
        
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
        overlay.continueButton.titleLabel?.font = AppFont.getBoldFont(size: 16)
        overlay.continueButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.setTitleColor(UIColor.white, for: .normal)
        overlay.skipButton.titleLabel?.font = AppFont.getRegularFont(size: 16)
        
        //Return the overlay view:
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        print(Int(currentPage))
        overlay.continueButton.tag = Int(position)
        
        if Int(currentPage) < titleArray.count-1 {
            overlay.continueButton.setTitle("بله", for: .normal)
            overlay.skipButton.setTitle("بگذر", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("بریم داخل اپلیکیشن!", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}


