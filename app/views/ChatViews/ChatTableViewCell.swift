//
//  ChatTableViewCell.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/15/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    
    var userNameLabel = UILabel()
    var notificationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createElements()
    }
    
    func createElements(){
        configUserNameLabel()
        configNotificationLabel()
    }
    
    func configUserNameLabel(){
        self.contentView.addSubview(self.userNameLabel)
        self.layoutUserNameLabel()
    }
    func configNotificationLabel(){
        self.notificationLabel.backgroundColor = UIColor.blue
        self.notificationLabel.textColor = UIColor.white
        self.notificationLabel.textAlignment = .center
        self.notificationLabel.layer.cornerRadius = 10
        self.notificationLabel.layer.masksToBounds = true
        self.contentView.addSubview(self.notificationLabel)
        self.layoutNotificationLabel()
    }
    
    func fillUI(model:MessagesViewModel,userId:Int){
        self.userNameLabel.text = "The user with id: \(model.getContactId(userId:userId)?.description ?? "")"
        let numberOfNotification = model.numberOfNotifications(userId:userId)
        self.notificationLabel.text = numberOfNotification.description
        if numberOfNotification == 0 {
            self.notificationLabel.isHidden = true
        } else {
            self.notificationLabel.isHidden = false
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init(coder:) has not been implemented")
        return nil
    }


}
