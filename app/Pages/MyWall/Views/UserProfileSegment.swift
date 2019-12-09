//
//  UserProfileSegment.swift
//  app
//
//  Created by Amir Hossein on 11/21/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class UserProfileSegment: UIView {

    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userId: UILabel!
    @IBOutlet weak var userPhoneNumber: UILabel!
    @IBOutlet weak var showCharityBtn: UIButton!

    var viewModel: UserProfileViewModel? {didSet {bindToViewModel()}}

    override func awakeFromNib() {
        showCharityBtn.layer.cornerRadius = 8
        showCharityBtn.setTitle(LanguageKeys.charity.localizedString, for: .normal)
    }

    func bindToViewModel() {
        viewModel?.$profile.bind = {[weak self] profile in
            self?.updateUI(profile: profile)
        }
        viewModel?.$loadingState.bind = {[weak self] state in
            self?.updateLoadingState(state: state)
        }
    }

    func updateLoadingState(state: ViewLoadingState) {
        switch state {
        case .loading:
            self.loadingView.show()
            self.contentView.hide()
        default:
            self.loadingView.hide()
            self.contentView.show()
        }
    }

    func updateUI(profile: UserProfile?) {
        setProfileImage(profile: profile)
        self.userName.text = profile?.name ?? LanguageKeys.user.localizedString
        self.userId.text = "\(LanguageKeys.identifier.localizedString): \(profile?.id.localizedNumber ?? "")"

        if let phoneNumber = profile?.phoneNumber {
            self.userPhoneNumber.text = "\(phoneNumber.localizedNumber)"
        } else {
            self.userPhoneNumber.text = ""
        }

        let isCharity = profile?.isCharity == true
        showCharityBtn.isHidden = !isCharity

    }

    fileprivate func setProfileImage(profile: UserProfile?) {
        let imagePlaceholder = UIImage(named: AppImages.BlankAvatar)
        if let url = URL(string: profile?.image ?? "") {
            self.profileImage.kf.setImage(with: url, placeholder: imagePlaceholder)
        } else {
            self.profileImage.image = imagePlaceholder
        }
    }

}
