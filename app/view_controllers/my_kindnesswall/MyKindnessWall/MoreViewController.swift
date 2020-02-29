//
//  MoreViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/14/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import Apollo

class MoreViewController: UIViewController {

    @IBOutlet weak var adminStackView: UIStackView!
    @IBOutlet weak var userStackView: UIStackView!

    @IBOutlet weak var blackListBtn: UIButton!
    @IBOutlet weak var versionNoLbl: UILabel!

    @IBOutlet weak var bugReportBtn: UIButton!
    @IBOutlet weak var aboutKindnessWallBtn: UIButton!
    @IBOutlet weak var statisticBtn: UIButton!
    @IBOutlet weak var contactUsBtn: UIButton!
    @IBOutlet var loginLogoutBtn: UIButton!
    @IBOutlet var addNewCharityBtn: UIButton!

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var passcodeTouchIDBtn: UIButton!

    let userDefaultService = UserDefaultService()
    let keychainService = KeychainService()
    
    var moreViewModel = MoreViewModel()

    var moreCoordinator: MoreCoordinator
    init(moreCoordinator: MoreCoordinator) {
        self.moreCoordinator = moreCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func shareApp(_ sender: Any) {
        AppDelegate.me().appCoordinator.shareApp()
    }

    @IBAction func showMyWall(_ sender: Any) {
        guard moreViewModel.isLogedin() else {
            AppDelegate.me().appCoordinator.showLoginVC()
            return
        }
        moreCoordinator.showMyWall()
    }

    @IBAction func showBlockedChats(_ sender: Any) {
        moreCoordinator.showContacts()
    }

    @IBAction func addNewCharity(_ sender: Any) {
        guard moreViewModel.isLogedin() else {
            AppDelegate.me().appCoordinator.showLoginVC()
            return
        }

        guard moreViewModel.isAdmin() else {
                FlashMessage.showMessage(body: LanguageKeys.accessError.localizedString, theme: .error)
                return
        }
        moreCoordinator.showCharitySignupEditView()
    }

    @IBAction func showReviewQueue(_ sender: Any) {
        guard moreViewModel.isLogedin() else {
            AppDelegate.me().appCoordinator.showLoginVC()
            return
        }

        guard moreViewModel.isAdmin() else {
                FlashMessage.showMessage(body: LanguageKeys.accessError.localizedString, theme: .error)
                return
        }
        moreCoordinator.showGiftReview()
    }

    @IBAction func showMyProfile(_ sender: Any) {
        guard moreViewModel.isLogedin() else {
            AppDelegate.me().appCoordinator.showLoginVC()
            return
        }
        moreCoordinator.showProfile()
    }

    @IBAction func passcodeTouchIDBtnClicked(_ sender: Any) {
        if keychainService.isPasscodeSaved() {
            moreCoordinator.showLockScreenView()
        } else {
            moreCoordinator.showLockSetting()
        }
    }

    @IBAction func switchLanguageBtnClicked(_ sender: Any) {
        moreCoordinator.showLanguageView()
    }
    @IBAction func switchApplicationCountryAction(_ sender: Any) {
        moreCoordinator.showCountrySwitchPage()
    }
    
    @IBAction func logoutBtnClicked(_ sender: Any) {

        guard moreViewModel.isLogedin() else {
            AppDelegate.me().appCoordinator.showLoginVC()
            setLoginLogoutBtnTitle()
            return
        }

        moreCoordinator.showLogoutAlert {[weak self] in
            self?.keychainService.clearUserSensitiveData()
            AppDelegate.me().appCoordinator.refreshAppAfterSwitchUser()

            UIApplication.shared.shortcutItems = []
            self?.setLoginLogoutBtnTitle()
        }
    }

    @IBAction func contactUsBtnClicked(_ sender: Any) {
        moreCoordinator.showContactUsView()
    }

    @IBAction func statisticBtnAction(_ sender: Any) {
        moreCoordinator.showStatisticView()
    }

    @IBAction func aboutKindnessWallBtnAction(_ sender: Any) {
        moreCoordinator.showIntro()
    }

    @IBAction func bugReportBtnAction(_ sender: Any) {
        moreCoordinator.openTelegram()
    }

    func setAllTextsInView() {
        setLoginLogoutBtnTitle()

        self.navigationItem.title=LanguageKeys.more.localizedString

//        contactUsBtn.setTitle(AppLiteral.contactUs, for: .normal)
//        bugReportBtn.setTitle(AppLiteral.bugReport, for: .normal)
//        aboutKindnessWallBtn.setTitle(AppLiteral.aboutKindnessWall, for: .normal)
//        statisticBtn.setTitle(AppLiteral.statistic, for: .normal)
    }

    func setLoginLogoutBtnTitle() {
        if moreViewModel.isLogedin() {
            loginLogoutBtn.setTitle(
                LanguageKeys.logout.localizedString +
                    AppLanguage.getNumberString(
                        number: (userDefaultService.getPhoneNumber() ?? "")), for: .normal)
        } else {
            loginLogoutBtn.setTitle(LanguageKeys.login.localizedString, for: .normal)
        }
    }

    deinit {
        print("MoreViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollview.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)

        versionNoLbl.text = LanguageKeys.AppVersion.localizedString + AppLanguage.getNumberString(number: moreViewModel.getVersionBuildNo())

        moreViewModel.getRepoInfo()
    }

    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)

        setAllTextsInView()
        adminStackView.isHidden = !moreViewModel.isAdmin()
        userStackView.isHidden = !moreViewModel.isLogedin()
    }

}
