//
//  UBChatListVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import HSPopupMenu
import AlamofireObjectMapper
import ObjectMapper
import SlideMenuControllerSwift
  
import LanguageManager_iOS
  
  
  

class UBChatListVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    var listOfChat : UserResponse?
    private let refreshControl = UIRefreshControl()
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var menuArray: [HSMenu] = []
    var userObj : Session?
    var listOfUnread : WelcomeUnreadMessage?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
    override func viewDidLoad() {
        super.viewDidLoad()
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        let menu1 = HSMenu(icon: nil, title: "New Chat".localized())
        let menu2 = HSMenu(icon: nil, title: "New Group".localized())
        menuArray = [menu1, menu2]
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(UBChatListVC.updateChatList), name: Notification.Name("CreateGroup"), object: nil)
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.didMessageDisplay(_:)), name: NSNotification.Name(rawValue: "messageReciverBadgeCount"), object: nil)
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
        tblViewss.registerCells([
            ChatListCell.self
        ])
        getInboxChat()
    }
    
    @objc func didMessageDisplay(_ notification: NSNotification) {
        let messagess = notification.object as? NSDictionary
        guard let message = messagess!["data"]  else {
            return
        }
        let stringObj = messagess!["data"] as? NSDictionary
        let jsonData = try? JSONSerialization.data(withJSONObject: stringObj!, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        let messageObj = Mapper<AllMessages>().map(JSONString: jsonString!)
        if let indexSelect = self.listOfChat?.messageList?.chatList?.firstIndex(where: {$0.id == messageObj?.chat_id}) {
            var messageCount = self.listOfChat?.messageList?.chatList![indexSelect].unreadMessageCount
            messageCount! += 1
            self.tabBarItem.badgeValue = "\(self.appDelegate.badgeCount)"
            self.listOfChat?.messageList?.chatList![indexSelect].unreadMessageCount = messageCount
            let indexPath = IndexPath(item: indexSelect , section: 0)
            let destinationIndex = IndexPath(item: 0 , section: 0)
            self.tblViewss.moveRow(at: indexPath, to: destinationIndex)
            let messaeObj =  self.listOfChat?.messageList?.chatList![indexSelect]
            self.listOfChat?.messageList?.chatList?.remove(at: indexSelect)
            self.listOfChat?.messageList?.chatList?.insert(messaeObj!, at: 0)
            self.tblViewss.reloadData()
        } else {
            getInboxChat()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUnReadMessageCount()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("<<<<<<<<< UBChatListVC delloc")
    }
    
    @IBAction private func btnLogo_Pressed(_ sender : UIButton) {
        getInboxChat()
        
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch Weather Data
        if Connectivity.isConnectedToInternet()  {
            getInboxChat()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    @objc func updateChatList() {
        getInboxChat()
    }
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
        // self.revealController.show(self.revealController.leftViewController)
    }
    
    func getInboxChat() {
        WebServiceManager.get(params: nil, serviceName: INBOX, serviceType: "Chat".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let self = self else {return}
            self.listOfChat = (response as! UserResponse)
            self.numberOfPage = self.listOfChat?.messageList?.last_page
            self.page = 1
            self.isPageRefreshing = false
            if self.listOfChat?.status == true {
                self.refreshControl.endRefreshing()
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
                self.page = self.page + 1
            } else {
                self.showAlert(title: KMessageTitle, message: (self.listOfChat?.message!)!, controller: self)
                self.refreshControl.endRefreshing()
            }
        }) { (error) in
        }
    }
    
    
    func getUnReadMessageCount() {
        WebServiceManager.get(params: nil, serviceName: UNREADMESSAGECOUNT , serviceType: "UnreadMessage".localized(), modelType: WelcomeUnreadMessage.self, success: { [weak self] (response) in
            guard let self = self else {return}
            self.listOfUnread = (response as! WelcomeUnreadMessage)
            if self.listOfUnread?.status == true {
                self.appDelegate.badgeCount = (self.listOfUnread?.objOfUnreadMsg!.unread)!
                if self.appDelegate.badgeCount == 0 {
                    self.tabBarItem.badgeValue = nil
                } else {
                    self.tabBarItem.badgeValue = "\(self.appDelegate.badgeCount)"
                }
            } else {
            }
            self.tblViewss.reloadData()
        }) { (error) in
        }
    }
    
    func makeRequest(pageSize : Int)  {
        print("page Size \(pageSize)")
        let serviceURL : String?
        serviceURL = "\(INBOX)?page=\(page)"
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: UserResponse.self , success: { [weak self] (response) in
            guard let self = self else {return}
            let responeOfPagination = (response as? UserResponse)!
            self.numberOfPage = responeOfPagination.messageList?.last_page
            if responeOfPagination.status == true {
                for (_ , obj) in ((responeOfPagination.messageList?.chatList?.enumerated())!) {
                    self.listOfChat?.messageList?.chatList?.append(obj)
                }
                self.isPageRefreshing = false
                self.tblViewss.tableFooterView?.isHidden = true
                self.activity.stopAnimating()
                self.tblViewss.reloadData()
                self.tblViewss.layoutIfNeeded()
                self.refreshControl.endRefreshing()
                self.page = self.page + 1
                
            }
            else
            {
                
            }
        }) { (error) in
        }
    }
    @IBAction private func btnNewGroup_Pressed(_ sender : UIButton) {
        let popupMenu = HSPopupMenu(menuArray: menuArray, arrowPoint: sender.center, arrowPosition: (LanguageManager.shared.currentLanguage == .ar ? HSPopupMenuArrowPosition.left : HSPopupMenuArrowPosition.right))
        popupMenu.delegate = self
        popupMenu.popUp()
    }
}


  
extension UBChatListVC: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        if index == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCreateGroupVC") as? UBCreateGroupVC
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBNewChatVC") as? UBNewChatVC
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
}

  
  
  

extension UBChatListVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfChat?.messageList?.chatList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: ChatListCell.self, for: indexPath)
        if self.listOfChat?.messageList?.chatList![indexPath.row].is_group == true {
            cell.lblNAme.text =  self.listOfChat?.messageList?.chatList![indexPath.row].group_name
            if self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount == 0 {
                cell.lblBadgeCount.isHidden = true
                let mesgeCount = self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount
                cell.lblBadgeCount.text = "\(mesgeCount!)"
            } else {
                cell.lblBadgeCount.isHidden = false
                let mesgeCount = self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount
                cell.lblBadgeCount.text = "\(mesgeCount!)"
            }
            
            guard  let image = self.listOfChat?.messageList?.chatList![indexPath.row].group_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
        } else {
            
            if self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount == 0 {
                cell.lblBadgeCount.isHidden = true
                let mesgeCount = self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount
                cell.lblBadgeCount.text = "\(mesgeCount!)"
            } else {
                cell.lblBadgeCount.isHidden = false
                let mesgeCount = self.listOfChat?.messageList?.chatList![indexPath.row].unreadMessageCount
                cell.lblBadgeCount.text = "\(mesgeCount!)"
            }
            
            if self.listOfChat?.messageList?.chatList![indexPath.row].identity_type == 1   {
                if self.listOfChat?.messageList?.chatList![indexPath.row].dtail?.user_id == userObj?.id  {
                    cell.lblNAme.text =  self.listOfChat?.messageList?.chatList![indexPath.row].chatUser?.full_name
                    guard  let image =   self.listOfChat?.messageList?.chatList![indexPath.row].chatUser?.profile_image  else   {
                        return cell
                    }
                    WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                } else {
                    cell.lblNAme.text  = "Anonymous".localized()
                    cell.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                }
                
            }
            else {
                cell.lblNAme.text =  self.listOfChat?.messageList?.chatList![indexPath.row].chatUser?.full_name
                guard  let image =   self.listOfChat?.messageList?.chatList![indexPath.row].chatUser?.profile_image  else   {
                    return cell
                }
                WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                
            }
        }
        
        //        if self.listOfChat?.messageList?.chatList![indexPath.row].latest_message != nil {
        //            cell.lblMessage.text = self.listOfChat?.messageList?.chatList![indexPath.row].latest_message?.message
        //            cell.imgOfLastSeen.isHidden = false
        //        } else {
        //            cell.lblMessage.text = "Image"
        //            cell.imgOfLastSeen.isHidden = true
        //
        //        }
        
        if self.listOfChat?.messageList?.chatList![indexPath.row].latest_message == nil {
            cell.lblMessage.text = ""
            cell.imgOfCam.isHidden = true
            cell.imgOfLastSeen.isHidden = true
            
            
        } else if self.listOfChat?.messageList?.chatList![indexPath.row].latest_message?.message == nil {
            cell.lblMessage.text = "Image".localized()
            cell.imgOfCam.isHidden = false
            cell.imgOfLastSeen.isHidden = false
            //            cell.heightOfCam.constant = 10.0
            //            cell.widthOfCameraIcon.constant = 10.0
            
        }
        else {
            cell.lblMessage.text = self.listOfChat?.messageList?.chatList![indexPath.row].latest_message?.message
            cell.imgOfCam.isHidden = true
            cell.imgOfLastSeen.isHidden = false
            
            
        }
        
        cell.lblDate.text = WAShareHelper.getFormattedDate(string: ((self.listOfChat?.messageList?.chatList![indexPath.row].created_at)!))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 71.0
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBChatDetailVC") as? UBChatDetailVC
        vc!.selectGroupOrUser = self.listOfChat?.messageList?.chatList![indexPath.row]
        vc?.delegate = self
        vc?.selectIndex = indexPath.row
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
        if scrollView == tblViewss {
            if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
                if isPageRefreshing == false {
                    isPageRefreshing = true
                    if page < numberOfPage! {
                        self.makeRequest(pageSize: self.page)
                        self.tblViewss.tableFooterView = self.activity
                        self.activity.startAnimating()
                        self.tblViewss.tableFooterView?.isHidden = false
                    } else {
                        
                    }
                    
                }  else {
                }
            } else {
            }
            
        }
        
    }
}
  
extension UBChatListVC : DeleteGroupDelegate  {
    func deleteGroupFromList(checkIndex: Int) {
        let selectList  = self.listOfChat?.messageList?.chatList![checkIndex].id
        DispatchQueue.global().async { [weak self] in
            guard let self = self else {return}
            if let index  = self.listOfChat?.messageList?.chatList!.index(where: {$0.id == selectList}) {
                self.listOfChat?.messageList?.chatList?.remove(at: index)
            }
            DispatchQueue.main.sync { [weak self] in
                guard let self = self else {return}
                self.tblViewss.reloadData()
            }
        }
    }
    
    func updateView(selectChat: ChatList, indexSelect: Int) {
        //        self.listOfChat?.messageList?.chatList![indexSelect] = selectChat
        //        self.tblViewss.reloadData()
    }
}
