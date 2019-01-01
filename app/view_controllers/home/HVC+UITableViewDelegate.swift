//
//  HVC+UITableViewDelegate.swift
//  app
//
//  Created by Hamed.Gh on 1/1/19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import TapsellSDKv3


extension HomeViewController:UITableViewDelegate {
    
    func show(ad:TapsellAd) {
        let showOptions = TSAdShowOptions()
        showOptions.setOrientation(OrientationUnlocked)
        showOptions.setBackDisabled(false)
        showOptions.setShowDialoge(false)
        
        Tapsell.setAdShowFinishedCallback { [weak self](ad, completed) in
            if(ad!.isRewardedAd() && completed){
                // give reward to user if neccessary
            }
        }
        
        ad.show(
            with: showOptions,
            andOpenedCallback:{ [weak self](tapsellAd) in
                print("\n\n andOpenedCallback \n\n")
                
            }, andClosedCallback:{ (tapsellAd) in
                print("\n\n andClosedCallback \n\n")
        })
        
        self.userDefault.set(
            Float(Date().timeIntervalSinceReferenceDate),
            forKey: AppConst.UserDefaults.LastTimeISawAd)
    }
    
    func isMoreThanOneDayIDidntSawAd()->Bool {
        let lastTimeISawAd = userDefault.float(forKey: AppConst.UserDefaults.LastTimeISawAd)
        let currentDateTime = Float(Date().timeIntervalSinceReferenceDate)
        if currentDateTime > lastTimeISawAd + NumberOfSecondsOfOneDay {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if vm.gifts[indexPath.row].isAd == nil || vm.gifts[indexPath.row].isAd == false {
            if let ad = self.videoInterstitialAd, self.isMoreThanOneDayIDidntSawAd()
            {
                self.show(ad:ad)
                return
            }
        }
        
        guard !(vm.gifts[indexPath.row].isAd ?? false) else {
            return
        }
        
        let controller = getGiftDetailVCFor(index: indexPath.row)
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func editHandler(){
        self.reloadPage()
        reloadOtherVCs()
    }
    
    func reloadOtherVCs(){
        AppDelegate.me().reloadTabBarPages(currentPage: self)
    }
    
}

