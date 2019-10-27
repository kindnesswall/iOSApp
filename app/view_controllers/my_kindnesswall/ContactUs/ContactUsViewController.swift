//
//  ContactUsViewController.swift
//  app
//
//  Created by Amir Hossein on 8/22/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController {
    
    
    class ContactUsModel {
        var image:UIImage?
        var link:String?
        
        init(image:UIImage?,link:String?) {
            self.image=image
            self.link=link
        }
        
        init(){
            
        }
        
    }
    
    var data = [ContactUsModel]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LanguageKeys.contactUs.localizedString
        
        self.collectionView.register(cellType: ContactUsCollectionViewCell.self)

        fillContactUsData()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func criticismsAndSuggestionsBtnAction(_ sender: Any) {
        let urlAddress = AppConst.URL.telegramLink
        URLBrowser(urlAddress: urlAddress).openURL()
    }
    
    func fillContactUsData(){
        
        let github = ContactUsModel(image: UIImage(named: AppImages.Github) , link: AppConst.URL.githubLink)
        
        let gmail = ContactUsModel(image: UIImage(named: AppImages.Gmail) , link: AppConst.URL.gmailLink)
        
        let instagram = ContactUsModel(image: UIImage(named: AppImages.Instagram) , link: AppConst.URL.instagramLink)
        
        let telegram = ContactUsModel(image: UIImage(named: AppImages.Telegram) , link: AppConst.URL.telegramLink)
        
        let facebook = ContactUsModel(image: UIImage(named: AppImages.Facebook) , link: AppConst.URL.facebookLink)
        
        let website = ContactUsModel(image: UIImage(named: AppImages.Website) , link: AppConst.URL.webSiteLink)
        
        data.append(github)
        data.append(gmail)
        data.append(instagram)
        data.append(telegram)
        data.append(facebook)
        data.append(website)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setDefaultStyle()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ContactUsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactUsCollectionViewCell.identifier, for: indexPath) as! ContactUsCollectionViewCell
        
        cell.setUI(data: data[indexPath.item])
        
        return cell
    }
    
    
}

extension ContactUsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.data[indexPath.item]
        guard let urlAddress = item.link else {
            return
        }
        URLBrowser(urlAddress: urlAddress).openURL()
    }
}

extension ContactUsViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.frame.width
        
        let numberOfItemsInRow : CGFloat = 4
        
        let width = collectionViewWidth / numberOfItemsInRow
        
        let height = width
        
        return CGSize(width: width, height: height)
        
    }
}
