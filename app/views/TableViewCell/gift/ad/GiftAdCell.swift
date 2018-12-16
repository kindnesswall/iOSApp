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
    var btnClickedClouser:(()->())?
    @IBAction func btnClicked(_ sender: Any) {
        self.btnClickedClouser?()
    }
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var nativeBanner: TSNativeBannerAdView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setOnClickBtn(_ clouser:@escaping ()->()) {
        self.btnClickedClouser = clouser
    }
    
    func showAd() {
        
        Tapsell.requestNativeBannerAd(
            forZone: TapSellConstants.ZoneID.NativeBanner,
            andContainerView: nativeBanner,
            onRequestFilled: {
                print("native banner filled")
        },
            onNoAdAvailable: {
                print("no native banner available")},
            onError: {(error) in
                print("error: ", error ?? "Null")
        })
    }
}
