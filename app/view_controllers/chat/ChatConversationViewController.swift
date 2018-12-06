//import UIKit
//import AVFoundation
//import UICircularProgressRing
//import KeychainSwift
//
//class ChatConversationViewController: UIViewController {
//    
//    var loadingIndicator:LoadingIndicator?
//
//    @IBOutlet weak var sendMsgLoader: UIView!
//    
//    @IBOutlet weak var showFirstMsgBtn: UIButton!
//    
//    @IBOutlet weak var tableview: UITableView!
//    
//    @IBOutlet weak var messageTextField: UITextField!
//    
//    @IBOutlet weak var sendTextBtn: UIButton!
//    
//    @IBAction func showFirstMsgBtnClicked(_ sender: Any) {
//        
//        let indexPath = IndexPath.init(row: 0, section: 0)
//        self.tableview.scrollToRow(at: indexPath, at: .top, animated: true)
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if chatId != nil, chatId == 0 {
//            self.navigationItem.title="گفت و گوی عمومی"
//        }else{
//            self.navigationItem.title=otherUserName
//        }
//        
//        NavigationBarStyle.setDefaultStyle(navigationC: self.navigationController)
//        
//        NavigationBarStyle.setBackBtn(navigationItem: self.navigationItem, target: self, action: #selector(self.backBtnClicked))
//        
//        NavigationBarStyle.removeDefaultBackBtn(navigationItem: self.navigationItem)
//        self.navigationController?.navigationBar.isTranslucent=false
//    }
//    
//    
//    @objc func backBtnClicked(){
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    func setDefaultStateUI() {
//        self.messageTextField.isHidden = false
//    }
//    
//    var messages:[Message] = []
////    var downloadMsgs:[DownloadMessage] = []
//    
//    var chatId:Int?
//    var otherUserName:String?
//    
//    let apiMethods:ApiMethods = ApiMethods()
//
//    var myUserId:Int?
//    
//    @IBAction func sendTextMessageBtnClicked(_ sender: Any) {
//        guard let chatId = chatId else {
//            return
//        }
//        
//        guard let text = self.messageTextField.text else {
//            return
//        }
//        
//        self.loadingIndicator?.startLoading()
//        self.sendTextBtn.isHidden = true
//        
//        
//        
//        ApiMethods.sendMessage(chatId: chatId, messageText: text) { (status) in
//        
//            self.loadingIndicator?.stopLoading()
//            self.sendTextBtn.isHidden = true
//            
////            if status == APIStatus.DONE {
////
////                self.messageTextField.text = ""
////
////                for (index, item) in self.messages.enumerated() {
////                    item.index = index + 1
////                }
////
////                let msg = Message()
////                msg.sender_id = self.myUserId
////                msg.text = text
////                msg.message_type = "text"
////                msg.profileImageUrl = ""
////
////                let time:Time = Time()
////                time.fa_time = "اخیرا"
////                msg.time = time
////
////                let sendMsg = DownloadMessage(msg: msg, index: 0)
////                self.downloadMsgs = [sendMsg] + self.downloadMsgs
////                self.tableview.reloadData()
////
////            } else {
////                FlashMessage.showMessage(body: "یه مشکلی به وجود اومد", theme: .error)
////            }
//        }
//        
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        tableview.delegate = self
//        tableview.dataSource = self
//        
//        tableview.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
//        
//        loadingIndicator=LoadingIndicator(view: self.sendMsgLoader)
//
////        myUserId = UserDefaults.standard.integer(forKey: AppConstants.USER_ID)
//        myUserId = Int(KeychainSwift().get(AppConstants.USER_ID) ?? "")
//        
//        // registering your nib
//        let bundle=Bundle(for: ChatConversationTableViewCell.self)
//        let yourNibName = UINib(nibName: "ChatConversationTableViewCell", bundle: bundle)
//        tableview.register(yourNibName, forCellReuseIdentifier: "ChatConversationTableViewCell")
//        
//        let bundle2=Bundle(for: OthersChatConversationTableViewCell.self)
//        let yourNibName2 = UINib(nibName: "OthersChatConversationTableViewCell", bundle: bundle2)
//        tableview.register(yourNibName2, forCellReuseIdentifier: "OthersChatConversationTableViewCell")
//        
//        
//        fetch()
//        
//        
//        tableview.contentInset=UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
//
//    }
//
////    let lazyLoadingCount=
//    var lastIndexLoaded=0
//
//    func fetch() {
//        guard let chatId = chatId else {
//            return
//        }
//        ApiMethods.getChatConversation(chatId: chatId, startIndex: lastIndexLoaded, complitionHandler: {
////            [weak self]
//            (output) in
//            
//            //            print(output)
////            if let result = output.result, let messages = result.list  {
//                //                self.messages.append(contentsOf: messages)
//                
////                let listLength = self.messages.count
////                for (index, msg) in messages.enumerated() {
////                    self.downloadMsgs.append(DownloadMessage(msg: msg, index:index+listLength))
////                }
////
////                self.tableview.reloadData()
////            }
//            
//        })
//    }
//}
//
//
//extension ChatConversationViewController : UITableViewDelegate{
//    
//}
//
//extension ChatConversationViewController : UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return messages.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if !tableView.isCellVisible(section: 0, row: 0) {
//            showFirstMsgBtn.isHidden = false
//        }else{
//            showFirstMsgBtn.isHidden = true
//        }
//        
//        
//        let itemIndex=indexPath.item+1
//        if itemIndex % ApiMethods.offset == 1 {
//            if lastIndexLoaded < itemIndex + ApiMethods.offset - 1 {
//                if self.messages.count == itemIndex + ApiMethods.offset - 1 {
//                    lastIndexLoaded=itemIndex+ApiMethods.offset-1
//                    fetch()
//                }
//            }
//        }
//        
//        
//        if messages[indexPath.row].sender_id == myUserId {
//            
//            let cell = tableview.dequeueReusableCell(withIdentifier: "ChatConversationTableViewCell", for: IndexPath(row: indexPath.row, section: 0)) as! ChatConversationTableViewCell
//            
//            cell.fillUI(msg: messages[indexPath.row])
//            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
//            
//            return cell
//        }else{
//            
//            let cell = tableview.dequeueReusableCell(withIdentifier: "OthersChatConversationTableViewCell", for:IndexPath(row: indexPath.row, section: 0)) as! OthersChatConversationTableViewCell
//            
//            cell.fillUI(msg: messages[indexPath.row])
//            
//            if chatId != 0 {
//                cell.usernameLabel.text = ""
//            }
//            
//            cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
//            
//            return cell
//            
//        }
//    }
//    
//    func setCell(rowNumber: Int)  {
//        if messages[rowNumber].sender_id == myUserId {
//            
//            let cell = tableview.cellForRow(at: IndexPath(row: rowNumber, section: 0)) as? ChatConversationTableViewCell
//            
//            
//            cell?.fillUI(msg: messages[rowNumber])
//            cell?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
//            
//        }else{
//            
//            let cell = tableview.cellForRow(at: IndexPath(row: rowNumber, section: 0)) as? OthersChatConversationTableViewCell
//            
//            cell?.fillUI(msg: messages[rowNumber])
//            
//            if chatId != 0 {
//                cell?.usernameLabel.text = ""
//            }
//            
//            cell?.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi));
//            
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        var height = CGFloat(80)
//        
//        if let txt  = messages[indexPath.row].text {
//            
//            height += txt.height(
//                withConstrainedWidth: AppDelegate.screenWidth - 120,
//                font: AppFont.getRegularFont(size: UIFont.systemFontSize)
//            )
//            
//        }else {
//            height += CGFloat(40)
//        }
//        
//        if messages[indexPath.row].sender_id != myUserId {
//            
//            height += CGFloat(20)
//            
//        }
//        
//        return height
//    }
//    
//}
//
