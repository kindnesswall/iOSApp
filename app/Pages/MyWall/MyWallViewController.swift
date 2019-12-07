//
//  MyWallViewController.swift
//  app
//
//  Created by AmirHossein on 3/2/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit
import KeychainSwift

class MyWallViewController: UIViewController {

    @IBOutlet weak var donatedStack: UIStackView!
    @IBOutlet weak var registeredStack: UIStackView!
    @IBOutlet weak var receivedStack: UIStackView!
    @IBOutlet weak var segmentControlStack: UIStackView!
    @IBOutlet weak var userProfileStack: UIStackView!
    
    var segmentControlView: MyWallSegmentControl?
    var userProfileView: UserProfileSegment?
    var donatedSegment: MyWallTableViewSegment?
    var registeredSegment: MyWallTableViewSegment?
    var receivedSegment: MyWallTableViewSegment?
    
    
    var userId:Int?
    
    var myWallCoordinator:MyWallCoordinator
    init(myWallCoordinator:MyWallCoordinator) {
        self.myWallCoordinator = myWallCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("MyWallViewController deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum GiftType {
        case registered
        case donated
        case received
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let userId = self.userId else {
            return
        }
        
        loadSegmentControl()
        loadUserProfileView(userId: userId)
        
        loadSegments(userId: userId)
        subscribeToSections()
        
        fetchGifts()
        self.updateUI()
    }
    
    func subscribeToSections() {
        registeredSegment?.presentDetailPage = { [weak self] gift in
            self?.presentDetailPage(gift: gift)
        }
        donatedSegment?.presentDetailPage = { [weak self] gift in
            self?.presentDetailPage(gift: gift)
        }
        receivedSegment?.presentDetailPage = { [weak self] gift in
            self?.presentDetailPage(gift: gift)
        }
    }
    
    func fetchGifts() {
        self.registeredSegment?.viewModel?.getGifts(beforeId: nil)
        self.donatedSegment?.viewModel?.getGifts(beforeId: nil)
        self.receivedSegment?.viewModel?.getGifts(beforeId: nil)
        self.userProfileView?.viewModel?.getProfile(loadingType: .initial)
    }
    
    func reloadGifts() {
        self.registeredSegment?.viewModel?.reloadGifts()
        self.donatedSegment?.viewModel?.reloadGifts()
        self.receivedSegment?.viewModel?.reloadGifts()
        self.userProfileView?.viewModel?.getProfile(loadingType: .refresh)
    }
    
    func updateUI(){
        switch self.segmentControlView?.segmentControl.selectedSegmentIndex {
        case 0:
            hideOrShowContainerView(type: .donated)
        case 1:
            hideOrShowContainerView(type: .received)
        case 2:
            hideOrShowContainerView(type: .registered)
        default:
            break
        }
    }
    
    func hideOrShowContainerView(type :GiftType){
        if type == .registered {
            self.registeredStack?.show()
        } else {
            self.registeredStack?.hide()
        }
        if type == .donated {
            self.donatedStack?.show()
        } else {
            self.donatedStack?.hide()
        }
        if type == .received {
            self.receivedStack?.show()
        } else {
            self.receivedStack?.hide()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NavigationBarStyle.setDefaultStyle(navigationC: navigationController)
        self.navigationItem.title = LanguageKeys.MyGiftsViewController_title.localizedString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//MARK: - Load Segments
extension MyWallViewController {
    func loadSegmentControl() {
        
        guard let segmentControlView = NibLoader.load(type: MyWallSegmentControl.self) else { return }
        
        segmentControlView.segmentChanged = {[weak self] in
            self?.updateUI()
        }
        segmentControlStack.addArrangedSubview(segmentControlView)
        self.segmentControlView = segmentControlView
    }
    
    func loadUserProfileView(userId: Int) {
        guard let userProfileView = NibLoader.load(type: UserProfileSegment.self) else { return }
        
        userProfileView.viewModel = UserProfileViewModel(userId: userId)
        
        userProfileStack.addArrangedSubview(userProfileView)
        self.userProfileView = userProfileView
    }
    
    func loadSegments(userId: Int) {
        loadRegisteredSegment(userId: userId)
        loadDonatedSegement(userId: userId)
        loadReceivedSegment(userId: userId)
    }
    
    func loadRegisteredSegment(userId: Int) {
        guard let registeredSegment =  NibLoader.load(type: MyWallTableViewSegment.self) else { return }
        
        registeredSegment.setViewModel(viewModel: RegisteredGiftViewModel(userId: userId))
        registeredSegment.emptyListMessage = LanguageKeys.noGiftRegistered.localizedString
        
        registeredStack.addArrangedSubview(registeredSegment)
        self.registeredSegment = registeredSegment
        
    }
    
    func loadDonatedSegement(userId: Int) {
        guard let donatedSegment = NibLoader.load(type: MyWallTableViewSegment.self) else { return }
        
        donatedSegment.setViewModel(viewModel: DonatedGiftViewModel(userId: userId))
        donatedSegment.emptyListMessage = LanguageKeys.noGiftDonated.localizedString
        
        donatedStack.addArrangedSubview(donatedSegment)
        self.donatedSegment = donatedSegment
        
    }
    
    func loadReceivedSegment(userId: Int) {
        guard let receivedSegment = NibLoader.load(type: MyWallTableViewSegment.self) else { return}
        
        receivedSegment.setViewModel(viewModel: ReceivedGiftViewModel(userId: userId))
        receivedSegment.emptyListMessage = LanguageKeys.noGiftReceived.localizedString
        
        receivedStack.addArrangedSubview(receivedSegment)
        self.receivedSegment = receivedSegment
    }
}

//MARK: - Subscribe

extension MyWallViewController {
    
    func presentDetailPage(gift: Gift) {
        
        self.myWallCoordinator.showGiftDetail(gift: gift, editHandler: { [weak self] in
            self?.editHandler()
        })
        
    }
    
    func editHandler(){
        reloadPage()
        reloadOtherVCs()
    }
    
    
    func reloadOtherVCs(){
        AppDelegate.me().appCoordinator.reloadTabBarPages(currentPage: self)
    }
}


extension MyWallViewController : ReloadablePage {
    func reloadPage(){
        self.reloadGifts()
    }
}
