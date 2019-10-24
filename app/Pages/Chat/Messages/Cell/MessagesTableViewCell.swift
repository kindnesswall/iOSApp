//
//  MessagesTableViewCell.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 3/15/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class MessagesTableViewCell: UITableViewCell {
    
    enum MessageUserType:String {
        case user
        case others
    }
    
    let margin:CGFloat = 6
    let userMargin:CGFloat = 50
    let textMargin:CGFloat = 10
    let stateLabelMaxWidth:CGFloat = 20
    let isNewMessageHeight:CGFloat = 40
    let isNewMessageLabelWidth:CGFloat = 140
    
    var containerStackView = UIStackView()
    var isNewMessageView = UIView()
    var messageContainerView = UIView()
    
    var messageContentView = UIView()
    var messageText = UILabel()
    var timeLabel = UILabel()
    var stateLabel = UILabel()
    
    var isNewMessageLabel = UILabel()
    var isNewMessageLLineLabel = UILabel()
    var isNewMessageRLineLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        guard let reuseIdentifier = reuseIdentifier, let type = MessageUserType(rawValue: reuseIdentifier) else {
            return
        }
        self.createElements(type: type)
    }
    
    func createElements(type: MessageUserType){
        configContainerStackView(type: type)
    }
    
    func configContainerStackView(type: MessageUserType){
        self.containerStackView.axis = .vertical
        self.contentView.addSubview(self.containerStackView)
        self.layoutContainerStackView()
        
        configIsNewMessageView(type: type)
        configMessageContainerView(type: type)
    }
    
    func configIsNewMessageView(type: MessageUserType){
        self.containerStackView.addArrangedSubview(self.isNewMessageView)
        self.layoutIsNewMessageView()
        self.configIsNewMessageLabels()
    }
    
    func configMessageContainerView(type: MessageUserType){
        self.containerStackView.addArrangedSubview(self.messageContainerView)
        configMessageContentView(type: type)
    }
    
    func configMessageContentView(type: MessageUserType){
        self.messageContentView.layer.cornerRadius = 10
        self.messageContainerView.addSubview(self.messageContentView)
        self.layoutMessageContentView(type: type)
        
        configMessageTextLabel(type: type)
        configTimeLabel(type: type)
        configStateLabel(type: type)
    }
    
    
    func configMessageTextLabel(type: MessageUserType){
        self.messageText.font = AppConst.Resource.Font.getRegularFont(size: 17)
        self.messageText.numberOfLines = 0
        self.messageText.textAlignment = .right
        self.messageContentView.addSubview(self.messageText)
        self.layoutMessageTextLabel(type: type)
    }
    
    func configTimeLabel(type: MessageUserType){
        self.timeLabel.font = AppConst.Resource.Font.getLightFont(size: 12)
        self.timeLabel.textAlignment = .right
        self.messageContentView.addSubview(self.timeLabel)
        self.layoutTimeLabel(type: type)
    }
    
    func configStateLabel(type: MessageUserType){
        self.stateLabel.font = UIFont(name: "Arial", size: 15)
        self.stateLabel.textAlignment = .center
        self.messageContentView.addSubview(self.stateLabel)
        self.layoutStateLabel(type: type)
    }
    
    func configIsNewMessageLabels(){
        self.isNewMessageLabel.font = AppConst.Resource.Font.getRegularFont(size: 15)
        self.isNewMessageLabel.textAlignment = .center
        self.isNewMessageLabel.text = LocalizationSystem.getStr(forKey: LanguageKeys.newMessage)
        
        let lineColor = UIColor.gray
        self.isNewMessageLLineLabel.backgroundColor = lineColor
        self.isNewMessageRLineLabel.backgroundColor = lineColor
        
        self.isNewMessageView.addSubview(self.isNewMessageLabel)
        self.isNewMessageView.addSubview(self.isNewMessageLLineLabel)
        self.isNewMessageView.addSubview(self.isNewMessageRLineLabel)
        
        self.layoutIsNewMessageLabel()
        self.layoutIsNewMessageLineLabel(line: self.isNewMessageLLineLabel, isLeft: true)
        self.layoutIsNewMessageLineLabel(line: self.isNewMessageRLineLabel, isLeft: false)
    }
    
    func updateUI(message:TextMessage?,messageType:MessageUserType){
        
        
        guard let message = message else {
            return
        }
        self.messageText.text = message.text
        self.timeLabel.text = AppLanguage.getNumberString(number: message.createdAt?.convertToDate()?.getClock() ?? "")
        self.isNewMessageView.isHidden = !(message.isFirstNewMessage ?? false)
        
        switch messageType {
        case .user:
            self.messageContentView.backgroundColor = UIColor.blue
            self.messageText.textColor = UIColor.white
            self.timeLabel.textColor = UIColor.white
            self.stateLabel.textColor = UIColor.white
            switch message.sendingState ?? .sent {
            case .sending:
                self.stateLabel.text = ""
            case .sent:
                self.stateLabel.text = "✔︎"
            case .failed:
                self.stateLabel.text = "❗️"
            }
        case .others:
            self.messageContentView.backgroundColor = UIColor.lightGray
            self.messageText.textColor = UIColor.black
            self.timeLabel.textColor = UIColor.black
            self.stateLabel.textColor = UIColor.black
            self.stateLabel.text = ""
        }

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init(coder:) has not been implemented")
        return nil
    }

}
