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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var completionHandler:((Int?,String?)->Void)?
    var closeHandler:(()->Void)?
    
    var viewModel : OptionsListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title=viewModel?.titleName
        self.viewModel?.registerCell(tableView: tableView)
        
        loadingIndicator.startAnimating()
        viewModel?.fetchElements(completionHandler: {
            [weak self] () in
            self?.loadingIndicator.stopAnimating()
            self?.tableView.reloadData()
        })
        
        self.setNavbar()
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("OptionsListViewController deinit")
    }
    
    func setNavbar(){
        NavigationBarStyle.setRightBtn(navigationItem: self.navigationItem, target: self, action: #selector(self.exitBtnAction), text: LocalizationSystem.getStr(forKey: LanguageKeys.cancel))
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
    

}

extension OptionsListViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getElementsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let viewModel=viewModel else {
            return UITableViewCell()
        }
        return viewModel.dequeueReusableCell(tableView: tableView, indexPath: indexPath)
        
    }
    
    
}
extension OptionsListViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cellData=viewModel?.returnCellData(indexPath: indexPath)
        completionHandler?(cellData?.0,cellData?.1)
        
        if let nestedViewModel = viewModel?.getNestedViewModel(indexPath: indexPath) {
            self.pushViewController(viewModel: nestedViewModel)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func pushViewController(viewModel:OptionsListViewModelProtocol){
       
        let controller=OptionsListViewController()
        controller.viewModel = viewModel
        controller.completionHandler=self.completionHandler
        controller.closeHandler=self.closeHandler
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
