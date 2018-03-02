//
//  MyGiftsViewController.swift
//  app
//
//  Created by AmirHossein on 3/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class MyGiftsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title="هدیه‌های من"
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

extension MyGiftsViewController : UITableViewDelegate {
    
}
extension MyGiftsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError()
    }
    
    
}
