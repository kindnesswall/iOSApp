//
//  ChatTableViewCell.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/15/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {

    static let cellHeight: CGFloat = 80
    let userImageSize: CGFloat = 40
    private let imagePlaceholder = UIImage(named: AppImages.BlankAvatar)
    
    let padding: CGFloat = 8
    let margin: CGFloat = 10

    var userNameLabel = UILabel()
    var charityNameLabel = UILabel()
    var charityNameContainer = UIView()
    var notificationLabel = UILabel()
    var userImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        self.createElements()
        self.layoutElements()
    }

    func createElements() {
        configUserImage()
        configUserNameLabel()
        configCharityNameContainer()
        configCharityNameLabel()
        configNotificationLabel()
    }
    
    func layoutElements() {
        self.layoutUserImage()
        self.layoutUserNameLabel()
        self.layoutCharityNameContainer()
        self.layoutCharityNameLabel()
        self.layoutNotificationLabel()
    }

    func configUserImage() {
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = userImageSize/2
        self.contentView.addSubview(self.userImage)
    }

    func configUserNameLabel() {
        self.userNameLabel.font = AppFont.get(.iranSansRegular, size: 17)
        self.userNameLabel.textAlignment = .right
        self.contentView.addSubview(self.userNameLabel)
    }
    func configCharityNameContainer() {
        charityNameContainer.backgroundColor = AppColor.Tint
        charityNameContainer.layer.cornerRadius = 8
        self.contentView.addSubview(charityNameContainer)
    }
    func configCharityNameLabel() {
        charityNameLabel.font = AppFont.get(.iranSansRegular, size: 17)
        charityNameLabel.textColor = .white
        charityNameContainer.addSubview(charityNameLabel)
    }
    
    func configNotificationLabel() {
        self.notificationLabel.backgroundColor = UIColor.blue
        self.notificationLabel.textColor = UIColor.white
        self.notificationLabel.textAlignment = .center
        self.notificationLabel.font = AppFont.get(.iranSansRegular, size: 15)
        self.notificationLabel.layer.cornerRadius = 10
        self.notificationLabel.layer.masksToBounds = true
        self.contentView.addSubview(self.notificationLabel)
    }

    func fillUI(viewModel: MessagesViewModel) {

        var defaultName = LanguageKeys.contact.localizedString
        defaultName += " (\(viewModel.contactProfile?.id.description ?? ""))"
        self.userNameLabel.text = viewModel.contactProfile?.name ?? defaultName

        let isCharity = viewModel.contactProfile?.isCharity == true
        self.charityNameContainer.isHidden = !isCharity
        self.charityNameLabel.text = viewModel.contactProfile?.charityName
        
        let numberOfNotification = viewModel.notificationCount
        self.notificationLabel.text = AppLanguage.getNumberString(number: numberOfNotification.description)

        if let imageAddr = viewModel.contactProfile?.image,
            let url = URL(string: imageAddr) {
            self.userImage.kf.setImage(with: url, placeholder: imagePlaceholder)
        } else {
            self.userImage.image = imagePlaceholder
        }

        if numberOfNotification == 0 {
            self.notificationLabel.isHidden = true
        } else {
            self.notificationLabel.isHidden = false
        }
    }

    required init?(coder aDecoder: NSCoder) {
        print("init(coder:) has not been implemented")
        return nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
    }

}
