//
//  CharityDetailViewController.swift
//  app
//
//  Created by Hamed Ghadirian on 10.07.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class CharityDetailViewController: UIViewController {

    @IBOutlet weak var charityImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var editCharityInfoButton: UIButton!
    @IBOutlet weak var managerNameLabel: UILabel!
    
    @IBOutlet weak var telephoneBtn: UIButton!
    @IBOutlet weak var mobileBtn: UIButton!
    @IBOutlet weak var websiteBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var instagramBtn: UIButton!
    @IBOutlet weak var telegramBtn: UIButton!
    @IBOutlet weak var twitterBtn: UIButton!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var vm:CharityDetailViewModel
    init(vm: CharityDetailViewModel) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onTelephoneClicked(_ sender: Any) {
        vm.callTelephone()
    }
    
    @IBAction func onMobileClicked(_ sender: Any) {
        vm.callMobile()
    }
    
    @IBAction func onWebsiteClicked(_ sender: Any) {
        vm.openWebsite()
    }
    
    @IBAction func onEmailClicked(_ sender: Any) {
        vm.openEmail()
    }
    
    @IBAction func onInstagramClicked(_ sender: Any) {
        vm.openInstagram()
    }
    
    @IBAction func onTelegramClicked(_ sender: Any) {
        vm.openTelegram()
    }
    
    @IBAction func onTwitterClicked(_ sender: Any) {
        vm.openTwitter()
    }
    
    @IBAction func onEditBtnClicked(_ sender: Any) {
        let charitySignupEditVM = CharitySignupEditVM(charity: self.vm.charity)
        let controller = CharitySignupEditViewController(vm: charitySignupEditVM)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fillUIWith(charity: vm.charity)
    }
    
    func fillUIWith(charity:Charity) {
        self.nameLabel.text = charity.name
        self.addressLabel.text = charity.address
        self.managerNameLabel.text = charity.manager
        
        if let path = charity.imageUrl {
            charityImage.kf.setImage(with: URL(string: path), placeholder: UIImage(named: AppImages.BlankAvatar))
        }

        telephoneBtn.setTitle(charity.telephoneNumber, for: .normal)
        mobileBtn.setTitle(charity.mobileNumber, for: .normal)
        websiteBtn.setTitle(charity.website, for: .normal)
        emailBtn.setTitle(charity.email, for: .normal)
        instagramBtn.setTitle(charity.instagram, for: .normal)
        telegramBtn.setTitle(charity.telegram, for: .normal)
        twitterBtn.setTitle(charity.twitter, for: .normal)
        descriptionTextView.text = charity.description
    }
    
}
