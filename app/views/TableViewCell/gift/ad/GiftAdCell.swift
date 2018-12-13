//
//  GiftAdCell.swift
//  app
//
//  Created by Amir Hossein on 12/12/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import TapsellSDKv3

class GiftAdCell: UITableViewCell {

    
    @IBOutlet weak var sponsorLbl: UILabel!
    @IBAction func btnClicked(_ sender: Any) {

    }
    @IBOutlet weak var btn: UIButton!
    
//    @IBOutlet weak var nativeBanner: TSNativeVideoAdView!
        @IBOutlet weak var nativeBanner: TSNativeBannerAdView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
//        Tapsell.requestNativeVideoAd(
//            forZone: TapSellConstants.ZoneID.NativeVideo,
//            andContainerView: nativeBanner,
//            onRequestFilled: {
//
//        },
//            onNoAdAvailable: {
//
//        }) { (error) in
//
//        }
        
//        Tapsell.requestNativeVideoAd(
//            forZone: TapSellConstants.ZoneID.NativeVideo,
//            andContainerView: nativeBanner,
//            onRequestFilled: {
//                print("native banner filled")
//                //                vc.updateRow(index: index)
//        },
//            onNoAdAvailable: { print("no native banner available")},
//            onError: { (error) in print("error: ", error ?? "Null")}
//        )
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func showAd() {
        self.sponsorLbl.text = "  اسپانسر  "
        Tapsell.requestNativeBannerAd(
            forZone: TapSellConstants.ZoneID.NativeBanner,
            andContainerView: nativeBanner,
            onRequestFilled: {
                print("native banner filled")
                self.sponsorLbl.text = "  اسپانسر  "
                //                vc.updateRow(index: index)
        },
            onNoAdAvailable: {
                DispatchQueue.main.sync {
                    self.sponsorLbl.text = ""
                }
                print("no native banner available")},
            onError: {(error) in
                print("error: ", error ?? "Null")
})
    }
}