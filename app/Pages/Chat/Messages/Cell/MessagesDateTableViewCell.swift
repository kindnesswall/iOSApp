//
//  MessagesDateTableViewCell.swift
//  KindnessWallChat
//
//  Created by Amir Hossein on 4/20/19.
//  Copyright © 2019 Amir Hossein. All rights reserved.
//

import UIKit

class MessagesDateTableViewCell: UITableViewCell {
    
    static let height:CGFloat = 24
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.backgroundColor = UIColor.white
        configElements()
    }
    
    func configElements(){
        configDateLabel()
    }
    
    func configDateLabel(){
        dateLabel.font = AppConst.Resource.Font.getRegularFont(size: 14)
        dateLabel.textColor = UIColor.gray
        dateLabel.textAlignment = .center
        self.contentView.addSubview(dateLabel)
        layoutDateLabel()
    }
    
    func updateUI(date:String?){
        self.dateLabel.text = AppLanguage.getNumberString(number: date ?? "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
