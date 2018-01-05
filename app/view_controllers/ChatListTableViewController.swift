import UIKit
import MGSwipeTableCell

class ChatListTableViewController: UITableViewController {
    
    var chats = [ChatAbs]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // registering your nib
        let bundle=Bundle(for: ChatListTableViewCell.self)
        let yourNibName = UINib(nibName: "ChatListTableViewCell", bundle: bundle)
        tableView.register(yourNibName, forCellReuseIdentifier: "ChatListTableViewCell")
       getChatList()
    }
    
    var sessions:[URLSession?]=[]
    var tasks:[URLSessionDataTask?]=[]
    
    func getChatList() {
        let mainURL: String = APIURLs.getChatList

        let jsonDicInput : [String : Any] = [:]

        APIRequest.request(url: mainURL, inputJson: jsonDicInput) { (data, response, error) in

            APIRequest.logReply(data: data)

            if let reply=APIRequest.readJsonData(data: data, outpuType: ResponseModel<[ChatAbs]>.self) {
//                if let status=reply.status,status==APIStatus.DONE {
//                    self.chats = reply.result!
//                }
            }
            self.tableView.reloadData()
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTableViewCell", for: indexPath) as! ChatListTableViewCell
        
        cell.leftButtons = [MGSwipeButton(title: "", icon:#imageLiteral(resourceName: "deleteBtn"), backgroundColor: UIColor.red,insets:UIEdgeInsets(top:0 , left: 25, bottom: 0, right: 25),callback:{
            (sender: MGSwipeTableCell!) -> Bool in
            self.chats.remove(at: indexPath.row)
            tableView.reloadData()
            return true
        })]
        
        cell.setValue(chat: chats[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       
        return CGFloat(55)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller=ChatConversationViewController(nibName: "ChatConversationViewController", bundle: Bundle(for: ChatConversationViewController.self))
        
        controller.chatId = chats[indexPath.row].chat_id
        if controller.chatId != 0 {
            
//            if let id = chats[indexPath.row].user_id, let user = AppDelegate.me().users[id] {
//
//                controller.otherUserName = user.name
//            }
            
        }
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NibLoader.loadViewFromNib(name: "SectionView", selfInstance: self, nibType: SectionView.self) as! SectionView
        view.setTitle(title: "لیست گفت و گوها")
        return view
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title="گفت و گو"
        NavigationBarStyle.setDefaultStyle(navigationC: self.navigationController)
        NavigationBarStyle.removeDefaultBackBtn(navigationItem: self.navigationItem)
        self.navigationController?.navigationBar.isTranslucent=false
    }
}
