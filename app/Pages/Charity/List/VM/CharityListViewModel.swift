//
//  CharityListViewModel.swift
//  app
//
//  Created by Hamed Ghadirian on 01.09.19.
//  Copyright © 2019 Hamed.Gh. All rights reserved.
//

import UIKit
import Kingfisher

class CharityListViewModel:NSObject {
    var charities:[Charity] = []
    
    func getList(compeletionHandler:()->()) {
        self.createCharityList()
        compeletionHandler()
    }
    
    func createCharityList() {
        for i in 0..<10 {
            charities.append(createACharity())
        }
    }
    
    func createACharity() -> Charity {
        let charity = Charity()
        
        charity.name = "امام علی"
        charity.manager = "شارمین"
        charity.address = "میدان انقلاب"
        
        charity.imageUrl = "https://ichef.bbci.co.uk/news/660/cpsprodpb/3E10/production/_106488851_capture.jpg"
        charity.registerId = "101"
        charity.registerDate = "29.8.2019"
        charity.telephoneNumber = "02188834567"
        charity.mobileNumber = "0920000000"
        charity.website = "https://sosapoverty.org/en/"
        charity.email = "info@sosapoverty.org"
        charity.instagram = "https://www.instagram.com/imamalisociety/"
        charity.telegram = "https://telegram.me/imamalisociety"
        charity.twitter = "https://twitter.com/imamalisociety?s=17"
        charity.description = "‏‏جمعیت مستقل امداد دانشجویی مردمی امام علی (ع) / ماموریت ما افزایش آگاهی جهت رسیدن به جهانی بر پایه صلح و عدالت است."
        
        return charity
    }
}

extension CharityListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(type: CharityTableViewCell.self, for: indexPath)
        let charity = charities[indexPath.row]
        cell.titleLabel.text = charity.name
        cell.subtitleLabel.text = charity.manager
        if let path = charity.imageUrl {
            cell.imageview.kf.setImage(with: URL(string: path), placeholder: UIImage(named: "blank_avatar"))
        }
        
        return cell
    }
}
