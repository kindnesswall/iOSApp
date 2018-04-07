//
//  ShowOptionsListViewController.swift
//  app
//
//  Created by AmirHossein on 2/9/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit


class OptionsListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    enum Option {
        case category
        case dateStatus
        case city(showRegion:Bool)
        case region(Int)
    }
    var option:Option?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    var hasDefaultOption=false
    
    var completionHandler:((String?,String?)->Void)?
    var closeHandler:(()->Void)?
    
    var categoryListViewModel:CategoryListViewModel?
    var dateStatusListViewModel:DateStatusListViewModel?
    var placeListViewModel:PlaceListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let option=option {
            switch option {
            case .category:
                
                self.navigationItem.title=AppLiteral.category
                tableView.registerNib(type: CategoryOptionsTableViewCell.self, nib: "CategoryOptionsTableViewCell")
               
               loadingIndicator.startAnimating()
                categoryListViewModel=CategoryListViewModel(hasDefaultOption:self.hasDefaultOption,completionHandler: {
                    [weak self] () in
                self?.loadingIndicator.stopAnimating()
                self?.tableView.reloadData()
                    
                })
            case .dateStatus:
                self.navigationItem.title=AppLiteral.newOrSecondHand
                tableView.registerNib(type: GenericOptionsTableViewCell.self, nib: "GenericOptionsTableViewCell")
                dateStatusListViewModel=DateStatusListViewModel()
                
            case .city:
                self.navigationItem.title=AppLiteral.placeOfTheGift
                tableView.registerNib(type: GenericOptionsTableViewCell.self, nib: "GenericOptionsTableViewCell")
                loadingIndicator.startAnimating()
                placeListViewModel=PlaceListViewModel(hasDefaultOption:self.hasDefaultOption,completionHandler: {
                    [weak self] () in
                    self?.loadingIndicator.stopAnimating()
                    self?.tableView.reloadData()
                })
            case .region(let cityId):
                self.navigationItem.title=AppLiteral.placeOfTheGift
                tableView.registerNib(type: GenericOptionsTableViewCell.self, nib: "GenericOptionsTableViewCell")
                loadingIndicator.startAnimating()
                placeListViewModel=PlaceListViewModel(hasDefaultOption:self.hasDefaultOption,cityId: cityId, completionHandler: {
                    [weak self] () in
                    self?.loadingIndicator.stopAnimating()
                    self?.tableView.reloadData()
                })
            }
        }
        
        self.setNavbar()
        
        // Do any additional setup after loading the view.
    }
    
    func setNavbar(){
        NavigationBarStyle.setRightBtn(navigationItem: self.navigationItem, target: self, action: #selector(self.exitBtnAction), text: AppLiteral.cancel)
        NavigationBarStyle.removeDefaultBackBtn(navigationItem: self.navigationItem)
    }
    
    @objc func exitBtnAction(){
        closeHandler?()
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: self.navigationController)
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

extension OptionsListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let option=option else {
            return 0
        }
        switch option {
        case .category:
            return categoryListViewModel?.categories.count ?? 0
        case .dateStatus:
            return dateStatusListViewModel?.dateStatus.count ?? 0

        case .city,.region:
            return placeListViewModel?.places.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let option=option else {
            fatalError()
        }
        
        switch option {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryOptionsTableViewCell", for: indexPath) as! CategoryOptionsTableViewCell
            categoryListViewModel?.setCell(cell: cell, indexPath: indexPath)
            return cell
        case .dateStatus:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericOptionsTableViewCell", for: indexPath) as! GenericOptionsTableViewCell
            dateStatusListViewModel?.setCell(cell: cell, indexPath: indexPath)
            return cell

        case .city,.region:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GenericOptionsTableViewCell", for: indexPath) as! GenericOptionsTableViewCell
            placeListViewModel?.setCell(cell: cell, indexPath: indexPath)
            return cell
        }
        
        
        
    }
    
    
}
extension OptionsListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option=option else {
            return
        }
        switch option {
        case .category:
            let category=categoryListViewModel?.returnCellData(indexPath: indexPath)
            completionHandler?(category?.id,category?.title)
            self.dismiss(animated: true, completion: nil)
        case .dateStatus:
            let dateStatus=dateStatusListViewModel?.returnCellData(indexPath: indexPath)
            completionHandler?(dateStatus?.id,dateStatus?.title)
            self.dismiss(animated: true, completion: nil)

        case .city(let showRegion):
            let place=placeListViewModel?.returnCellData(indexPath: indexPath)
            completionHandler?(place?.id?.description,place?.name)
            
            if showRegion && placeListViewModel?.hasAnyRegion(container_id: place?.id ?? -1) ?? false {
                self.pushViewController(option: .region(place?.id ?? -1))
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
        case .region:
            let place=placeListViewModel?.returnCellData(indexPath: indexPath)
            completionHandler?(place?.id?.description,place?.name)
            
            self.dismiss(animated: true, completion: nil)
            

        }
        
    }
    
    
    
    func pushViewController(option:Option){
        switch option {
        case .region(let cityId):
            let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
            controller.option = OptionsListViewController.Option.region(cityId)
            controller.completionHandler=self.completionHandler
            controller.closeHandler=self.closeHandler
            controller.hasDefaultOption=self.hasDefaultOption
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
        
    }
    
    
    
}
