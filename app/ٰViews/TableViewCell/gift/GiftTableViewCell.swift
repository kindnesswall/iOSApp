//
//  GiftTableViewCell.swift
//  app
//
//  Created by Hamed.Gh on 11/27/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
//import SDWebImage
import Kingfisher

class GiftTableViewCell: UITableViewCell {

    @IBOutlet var giftImage: UIImageView!
    @IBOutlet var giftTitle: UILabel!
    @IBOutlet var giftDate: UILabel!
    @IBOutlet var giftDescription: UILabel!

    @IBOutlet weak var giftCity: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var precentView: ProgressBarView!

    func filViews(gift: GiftPresenter) {

        giftTitle.text = gift.title
        giftDate.text = AppLanguage.getNumberString(number: gift.createdAt?.convertToDate()?.getPersianDate() ?? "")

        giftDescription.text = gift.description
        let address = Address(province: gift.provinceName, city: gift.cityName, region: gift.regionName)
        giftCity.text=address.address

        self.precentView.hide()
        self.giftImage.show()
        self.precentView.progress = 0

        if let urlStr = gift.giftImages?.first,
            let url = URL(string: urlStr) {

            self.giftImage.kf.setImage(
                with: url,
                placeholder: UIImage(named: AppImages.Placeholder),
                options: [.transition(.fade(0.6))], progressBlock: { [weak self]
                    receivedSize, totalSize in

                    let percentage = (Float(receivedSize) / Float(totalSize)) // * 100.0
                    if percentage == 1 {
                        self?.precentView.hide()
                        self?.giftImage.show()
                    } else {
                        self?.precentView.show()
                        self?.giftImage.hide()
                        self?.precentView.progress = percentage
                    }
            })

        }
//        else {
//            giftImage.image = UIImage(named: "placeholder")
//            self.precentView.hide()
//            self.giftImage.show()
//        }

    }
}
