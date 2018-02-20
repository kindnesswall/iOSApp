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
        case place(Int)
    }
    var option:Option?
    
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
                
                self.navigationItem.title="دسته بندی"
                tableView.registerNib(type: CategoryOptionsTableViewCell.self, nib: "CategoryOptionsTableViewCell")
                categoryListViewModel=CategoryListViewModel(completionHandler: {
                    [weak self] () in self?.tableView.reloadData()
                    
                })
            case .dateStatus:
                self.navigationItem.title="وضعیت نو یا دسته ‌دو بودن"
                tableView.registerNib(type: GenericOptionsTableViewCell.self, nib: "GenericOptionsTableViewCell")
                dateStatusListViewModel=DateStatusListViewModel()
                
            case .place(let container_id):
                self.navigationItem.title="محل هدیه"
                tableView.registerNib(type: GenericOptionsTableViewCell.self, nib: "GenericOptionsTableViewCell")
                placeListViewModel=PlaceListViewModel(container_id: container_id, completionHandler: {
                    [weak self] () in self?.tableView.reloadData()
                })
            }
        }
        
        self.setNavbar()
        
        // Do any additional setup after loading the view.
    }
    
    func setNavbar(){
        NavigationBarStyle.setRightBtn(navigationItem: self.navigationItem, target: self, action: #selector(self.exitBtnAction), text: "انصراف")
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
        case .place:
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
        case .place:
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
        case .place:
            let place=placeListViewModel?.returnCellData(indexPath: indexPath)
            completionHandler?(place?.id?.description,place?.name)
            
            if placeListViewModel?.hasNestedOption(container_id: place?.id ?? -1) ?? false {
                self.pushViewController(option: .place(place?.id ?? -1))
            } else {
                self.dismiss(animated: true, completion: nil)
            }
            
            

        }
        
    }
    
    
    
    func pushViewController(option:Option){
        switch option {
        case .place(let container_id):
            let controller=OptionsListViewController(nibName: "OptionsListViewController", bundle: Bundle(for:OptionsListViewController.self))
            controller.option = OptionsListViewController.Option.place(container_id)
            controller.completionHandler=self.completionHandler
            controller.closeHandler=self.closeHandler
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            break
        }
        
    }
    
    
    
}
