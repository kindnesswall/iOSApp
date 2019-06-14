//
//  ChatTableViewCell.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/15/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    static let cellHeight:CGFloat = 80
    let userImageSize:CGFloat = 40
    
    var userNameLabel = UILabel()
    var notificationLabel = UILabel()
    var userImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createElements()
    }
    
    func createElements(){
        configUserNameLabel()
        configUserImage()
        configNotificationLabel()
    }
    
    func configUserImage(){
        self.userImage.clipsToBounds = true
        self.userImage.layer.cornerRadius = userImageSize/2
        self.contentView.addSubview(self.userImage)
        self.layoutUserImage()
    }
    
    func configUserNameLabel(){
        self.userNameLabel.font = AppConst.Resource.Font.getRegularFont(size: 17)
        self.userNameLabel.textAlignment = .right
        self.contentView.addSubview(self.userNameLabel)
        self.layoutUserNameLabel()
    }
    func configNotificationLabel(){
        self.notificationLabel.backgroundColor = UIColor.blue
        self.notificationLabel.textColor = UIColor.white
        self.notificationLabel.textAlignment = .center
        self.notificationLabel.font = AppConst.Resource.Font.getRegularFont(size: 15)
        self.notificationLabel.layer.cornerRadius = 10
        self.notificationLabel.layer.masksToBounds = true
        self.contentView.addSubview(self.notificationLabel)
        self.layoutNotificationLabel()
    }
    
    func fillUI(viewModel:MessagesViewModel){
        let descriptionOfUserOnChatList = LocalizationSystem.getStr(forKey: LanguageKeys.descriptionOfUserOnChatList)
        let contactId = AppLanguage.getNumberString(number: viewModel.getContactId()?.description ?? "")
        self.userNameLabel.text = "\(descriptionOfUserOnChatList) \(contactId)"
        
        let numberOfNotification = viewModel.notificationCount
        self.notificationLabel.text = AppLanguage.getNumberString(number: numberOfNotification.description)
        
        self.userImage.image = UIImage(named: "blank_avatar")
        
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
