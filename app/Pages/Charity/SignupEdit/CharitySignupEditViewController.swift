//
//  CharitySignupEditViewController.swift
//  app
//
//  Created by Hamed Ghadirian on 10.07.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class CharitySignupEditViewController: UIViewController {

    @IBOutlet weak var charityImageView: UIImageView!

    @IBOutlet weak var managerNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var telegramTextField: UITextField!
    @IBOutlet weak var twitterTextField: UITextField!

    @IBOutlet weak var descriptionTextView: UITextView!

    var vm: CharitySignupEditVM
    init(vm: CharitySignupEditVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let charity = vm.charity {
            show(charity: charity)
        }
    }

    func show(charity: Charity) {

        nameTextField.text = charity.name
        managerNameTextField.text = charity.manager
        addressTextField.text = charity.address
        telegramTextField.text = charity.telegram
        telephoneTextField.text = charity.telephoneNumber
        mobileTextField.text = charity.mobileNumber
        websiteTextField.text = charity.website
        emailTextField.text = charity.email
        instagramTextField.text = charity.instagram
        twitterTextField.text = charity.twitter
        descriptionTextView.text = charity.description

        if let path = charity.imageUrl {
            charityImageView.kf.setImage(with: URL(string: path), placeholder: UIImage(named: AppImages.BlankAvatar))
        }

    }

    @IBAction func addNewOrEditData(_ sender: Any) {

    }
}
