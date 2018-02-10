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
        case city
    }
    var option:Option?
    
    var completionHandler:((String?,String?)->Void)?
    
    var categoryListViewModel=CategoryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let option=option {
            switch option {
            case .category:
                tableView.registerNib(type: CategoryOptionsTableViewCell.self, nib: "CategoryOptionsTableViewCell")
                categoryListViewModel.getCategories(completionHandler: {[weak self] () in self?.tableView.reloadData()})
            case .city:
                break
                
            }
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            return categoryListViewModel.categories.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let option=option else {
            fatalError()
        }
        
        switch option {
        case .category:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryOptionsTableViewCell", for: indexPath) as! CategoryOptionsTableViewCell
            categoryListViewModel.setCell(cell: cell, indexPath: indexPath)
            return cell
        default:
            fatalError()
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
            let category=categoryListViewModel.returnCellData(indexPath: indexPath)
            completionHandler?(category.id,category.title)
            self.navigationController?.popViewController(animated: true)
        default:
            fatalError()
        }
        
        
    }
    
}
