//
//  MoreViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift
import Apollo

class MoreViewController: UIViewController {

    @IBOutlet weak var versionNoLbl: UILabel!

    @IBOutlet weak var bugReportBtn: UIButton!
    @IBOutlet weak var aboutKindnessWallBtn: UIButton!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    let keychain = KeychainSwift()
    let userDefault=UserDefaults.standard

    @IBOutlet weak var passcodeTouchIDBtn: UIButton!

    @IBAction func shareApp(_ sender: Any) {
        AppDelegate.me().shareApp()
    }

    @IBAction func showReviewQueue(_ sender: Any) {
        guard let _=keychain.get(AppConst.KeyChain.Authorization) else {
            AppDelegate.me().showLoginVC()
            return
        }

        guard let isAdmin = keychain.getBool(AppConst.KeyChain.IsAdmin), isAdmin
             else {
                FlashMessage.showMessage(body: LocalizationSystem.getStr(forKey: LanguageKeys.imageUploadingError), theme: .error)
                return
        }
        let vm = HomeVM()
        vm.isReview = true
        let controller = HomeViewController(vm: vm)
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func showMyProfile(_ sender: Any) {
        guard let _=keychain.get(AppConst.KeyChain.Authorization) else {
            AppDelegate.me().showLoginVC()
            return
        }

        let controller = ProfileViewController ()
        let nc = UINavigationController.init(rootViewController: controller)
        self.tabBarController?.present(nc, animated: true, completion: nil)

    }

    @IBAction func passcodeTouchIDBtnClicked(_ sender: Any) {

        if AppDelegate.me().isPasscodeSaved() {
            let controller = LockViewController()
            controller.mode = .CheckPassCode
            controller.onPasscodeCorrect = {
                let controller = LockSettingViewController()
                self.navigationController?.pushViewController(controller, animated: true)
            }
            self.tabBarController?.present(controller, animated: true, completion: nil)
        } else {
            let controller = LockSettingViewController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }

    @IBAction func switchLanguageBtnClicked(_ sender: Any) {
        let controller = LanguageViewController()
        controller.languageViewModel.tabBarIsInitialized = true
        self.tabBarController?.present(controller, animated: true, completion: nil)
    }

    @IBAction func logoutBtnClicked(_ sender: Any) {

        if let _=keychain.get(AppConst.KeyChain.Authorization) { //UserDefaults.standard.string(forKey: AppConstants.Authorization) {

            let alert = UIAlertController(
                title: LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_title),
                message: LocalizationSystem.getStr(forKey: LanguageKeys.logout_dialog_text),
                preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.ok), style: UIAlertAction.Style.default, handler: { (_) in
                AppDelegate.me().logout()
                UIApplication.shared.shortcutItems = []
                self.setLoginLogoutBtnTitle()
            }))

            alert.addAction(UIAlertAction(title: LocalizationSystem.getStr(forKey: LanguageKeys.cancel), style: UIAlertAction.Style.default, handler: { (_) in
                alert.dismiss(animated: true, completion: {

                })
            }))

            self.present(alert, animated: true, completion: nil)

        } else {
            AppDelegate.me().showLoginVC()
            setLoginLogoutBtnTitle()
        }

    }

    @IBAction func contactUsBtnClicked(_ sender: Any) {
        let controller = ContactUsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func statisticBtnAction(_ sender: Any) {
        let controller = StatisticViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

    @IBAction func aboutKindnessWallBtnAction(_ sender: Any) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = (mainStoryboard.instantiateViewController(withIdentifier: "IntroViewController") as? IntroViewController) ?? IntroViewController()
        self.present(viewController, animated: true, completion: nil)
    }

    @IBAction func bugReportBtnAction(_ sender: Any) {
        let urlAddress = URIs.telegramLink
        URLBrowser(urlAddress: urlAddress).openURL()
    }

    func setAllTextsInView() {
        setLoginLogoutBtnTitle()

        self.navigationItem.title=LocalizationSystem.getStr(forKey: LanguageKeys.myWall)

//        contactUsBtn.setTitle(AppLiteral.contactUs, for: .normal)
//        bugReportBtn.setTitle(AppLiteral.bugReport, for: .normal)
//        aboutKindnessWallBtn.setTitle(AppLiteral.aboutKindnessWall, for: .normal)
//        statisticBtn.setTitle(AppLiteral.statistic, for: .normal)
    }

    func setLoginLogoutBtnTitle() {
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            loginLogoutBtn.setTitle(
                LocalizationSystem.getStr(forKey: LanguageKeys.logout) +
                    AppLanguage.getNumberString(
                        number: (userDefault.string(forKey: AppConst.UserDefaults.PHONE_NUMBER) ?? "")), for: .normal)
        } else {
            loginLogoutBtn.setTitle(LocalizationSystem.getStr(forKey: LanguageKeys.login), for: .normal)
        }
    }

    func setPasscodeBtnVisiblity() {
        if let _=keychain.get(AppConst.KeyChain.Authorization) {
            passcodeTouchIDBtn.show()
        } else {
            passcodeTouchIDBtn.hide()
        }
    }

    func getVersionBuildNo() -> String {
        let dic = Bundle.main.infoDictionary!
        let version = (dic["CFBundleShortVersionString"] as? String) ?? "get version failed"
        let buildNumber = (dic["CFBundleVersion"] as? String) ?? "get buildNumber failed"

        return version+"("+buildNumber+")"
    }

    deinit {
        print("MoreViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        versionNoLbl.text = LocalizationSystem.getStr(forKey: LanguageKeys.AppVersion) + AppLanguage.getNumberString(number: getVersionBuildNo())

        getRepoInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)

        setAllTextsInView()

        setPasscodeBtnVisiblity()
    }

    // MARK: : GraphQL
    let apollo: ApolloClient = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = ["Authorization": "Bearer \(GithubConstants.Token)"]

        let endPointUrl = URL(string: GithubConstants.EndPoint)

        return ApolloClient(networkTransport: HTTPNetworkTransport(url: endPointUrl!, configuration: config))
    }()

    func getRepoInfo() {
        let userInfo = UserInfoQuery()
        apollo.fetch(query: userInfo) { [weak self](result, error) in
            print("RepoInfo:")
            if let error = error {
                print(error)
                return
            }

            guard let name = result?.data?.user?.name else {
                print("no name")
                return
            }
            print("name: \(name)")

            guard let repos = result?.data?.user?.repositories.edges else {
                print("no repo")
                return
            }
            print("Repositories:")
            for rep in repos {
                if let name = rep?.node?.name {
                    print(name)
                }
            }
        }
    }
}
