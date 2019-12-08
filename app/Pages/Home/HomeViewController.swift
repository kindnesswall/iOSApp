//
//  HomeViewController.swift
//  app
//
//  Created by Hamed.Gh on 10/13/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import JGProgressHUD
import Firebase

class HomeViewController: UIViewController {

    @IBOutlet var tableview: UITableView!
    @IBOutlet weak var emptyListMessageLabel: UILabel!

    let vm: HomeVM
    let userDefault=UserDefaults.standard

    let numberOfSecondsOfOneDay: Float = 26*60*60

    let hud = JGProgressHUD(style: .dark)

    var lazyLoadingIndicator: LoadingIndicator?
    var tableViewCellHeight: CGFloat=122

    var refreshControl=UIRefreshControl()

    var categotyBarBtn: UIBarButtonItem?
    var provinceBarBtn: UIBarButtonItem?

    var previewRowIndex: Int?
    var homeCoordiantor: HomeCoordinator?

    init(vm: HomeVM, homeCoordiantor: HomeCoordinator) {
        self.vm = vm
        self.homeCoordiantor = homeCoordiantor
        super.init(nibName: nil, bundle: nil)
    }

    init(vm: HomeVM) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("HomeViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.vm.delegate = self
        emptyListMessageLabel.text = vm.getEmptyListMessage()

        registerForPreviewing(with: self, sourceView: tableview)

//        self.tableview.hide()

        hud.textLabel.text = LanguageKeys.loading.localizedString

        self.lazyLoadingIndicator=LoadingIndicator(viewBelowTableView: self.view, cellHeight: tableViewCellHeight/2)
        self.tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: tableViewCellHeight/2, right: 0)

        configRefreshControl()

        setNavigationBar()

        tableview.dataSource = vm
        tableview.delegate = self

        self.tableview.register(type: GiftTableViewCell.self)

        vm.getGifts(beforeId: nil)
    }

    func configRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(self.refreshControlAction), for: .valueChanged)
        refreshControl.tintColor=AppColor.Tint
        self.tableview.addSubview(refreshControl)
    }

    @objc func refreshControlAction() {
        self.reloadPage()
        self.hud.dismiss(afterDelay: 0)
    }

    func setTableViewLazyLoading(isLoading: Bool) {
        if isLoading {
            self.lazyLoadingIndicator?.startLoading()
        } else {
            self.lazyLoadingIndicator?.stopLoading()
        }
    }

    func setNavigationBar() {
        categotyBarBtn=UINavigationItem.getNavigationItem(
            target: self,
            action: #selector(self.categoryFilterBtnClicked),
            text: LanguageKeys.allGifts.localizedString,
            font: AppFont.getRegularFont(size: 16)
        )
        self.navigationItem.rightBarButtonItems=[categotyBarBtn!]

        provinceBarBtn=UINavigationItem.getNavigationItem(target: self, action: #selector(self.cityFilterBtnClicked), text: LanguageKeys.allProvinces.localizedString, font: AppFont.getRegularFont(size: 16))
        self.navigationItem.leftBarButtonItems=[provinceBarBtn!]
    }

    @objc func categoryFilterBtnClicked() {

        let controller=OptionsListViewController()
        let viewModel = CategoryListVM(hasDefaultOption: true)
        controller.viewModel=viewModel
        controller.completionHandler = { [weak self] (id, name) in

            print("Selected Category id: \(id?.description ?? "")")
            self?.vm.categoryId=id
            self?.categotyBarBtn?.title=name
            self?.reloadPage()

        }
        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)

    }

    @objc func cityFilterBtnClicked() {

        let controller=OptionsListViewController()
        let viewModel = PlaceListViewModel(placeType: .province, showCities: false, showRegions: false, hasDefaultOption: true)
        controller.viewModel=viewModel
        controller.completionHandler = { [weak self] (id, name) in

            print("Selected province id: \(id?.description ?? "")")
            self?.vm.provinceId=id
            self?.provinceBarBtn?.title=name
            self?.reloadPage()

        }

        let nc=UINavigationController(rootViewController: controller)
        self.present(nc, animated: true, completion: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.setAllTextsInView()
    }

    func setAllTextsInView() {
        self.navigationItem.title=LanguageKeys.home.localizedString
        if self.vm.categoryId==nil {
            self.categotyBarBtn?.title=LanguageKeys.allGifts.localizedString
        }
        if self.vm.provinceId==nil {
            self.provinceBarBtn?.title=LanguageKeys.allProvinces.localizedString
        }
    }
}

extension HomeViewController: ReloadablePage {
    func reloadPage() {
        self.vm.reloadPage()
    }
}
