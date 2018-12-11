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
import TapsellSDKv3

//protocol UpdateCell {
//    func name(<#parameters#>) -> <#return type#> {
//    <#function body#>
//    }
//}
class GiftAdTableViewCell: UITableViewCell {

    @IBOutlet weak var nativeBanner: TSNativeBannerAdView!
    @IBOutlet weak var titleLbl: UILabel!
//    var vc:HomeViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showAd() {

        Tapsell.requestNativeBannerAd(
            forZone: TapSellConstants.ZoneID.NativeBanner,
            andContainerView: nativeBanner,
            onRequestFilled: {
                print("native banner filled")
                print(self.titleLbl.text)
//                vc.updateRow(index: index)
        },
            onNoAdAvailable: { print("no native banner available")},
            onError: { (error) in print("error: ", error ?? "Null")})
        
        
    }
}
