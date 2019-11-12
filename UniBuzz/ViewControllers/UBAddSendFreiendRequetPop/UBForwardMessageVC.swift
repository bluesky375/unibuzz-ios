//
//  UBForwardMessageVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 31/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  

protocol  MessageForwardDelegate : class {
    func messaegeForward(obj : MessageObject)
}

class UBForwardMessageVC: UIViewController {
    var userFriend : UserResponse?
    @IBOutlet weak var tblViewss: UITableView!
    var messageId : Int?
    private var friendList : [String] = []
    weak var delegate : MessageForwardDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getALlFriendList()
        // Do any additional setup after loading the view.
    }
    
    func getALlFriendList() {
        WebServiceManager.get(params: nil, serviceName: FRIENDLIST, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            self.userFriend = (response as! UserResponse)
            if self.userFriend?.status == true {
                //                self.numberOfPage = self.userFeeds?.feeds?.post?.last_page
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
                //                self.refreshControl.endRefreshing()
                //                self.refreshControl.stopAnimating()
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFriend?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    
    @IBAction private func btnSend(_ sender : UIButton) {
        if friendList.count > 0 {
        var param = [:] as [String : Any]
        param = ["friends"                           :  friendList,
                "message_id"                         :   "\(messageId!)"
                ]
        SVProgressHUD.show(withStatus: "Loading".localized())
        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: FORWARDMESSAGE , serviceType: "Chat".localized(), modelType: MessageObject.self, success: {[weak self] (responseData) in
            if  let post = responseData as? MessageObject {
                if post.status == true {
                    SVProgressHUD.show(withStatus: post.message)
//                    self!.inboxChat?.listOfChat?.listOfAllMessage?.append(post.messagee!)
                    let JSONString = post.toJSONString(prettyPrint: true)
                    let userss = MessageObject(JSONString: JSONString!)
//                    self!.isReply = false
                    SKSocketConnection.socketSharedConnection.sendMessage(keyName: "senderEvent", obj: userss!)
                    self?.delegate?.messaegeForward(obj: userss!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                        SVProgressHUD.dismiss()
                            self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
            }, fail: { (error) in
                //
        }, showHUD: true)
        } else {
            self.showAlert(title: KMessageTitle, message: "Please select the user to send message".localized(), controller: self)
        }
        
        
    }

}

extension UBForwardMessageVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
            if  self.userFriend?.friendObject?.friendList!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Friend  in your List.".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }
            
       
        
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return self.userFriend?.friendObject?.friendList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: GroupCell.self, for: indexPath)
        
            cell.lblName.text = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.full_name
//            if isSelectedFriend.contains((self.userFriend?.friendObject?.friendList![indexPath.row].id)!) {
//                cell.btnSelect.isSelected = true
//            } else {
//                cell.btnSelect.isSelected = false
//            }
            cell.delegate = self
            cell.selectIndex = indexPath
            if self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name != nil {
                cell.lblGroupName.text = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name
            } else {
                cell.lblGroupName.text = "".localized()
            }
            guard  let image = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.profile_image  else   {
                return cell
            }
            cell.imgofUser.setImage(with: image, placeholder: UIImage(named: "profile2"))
            let cgFloat: CGFloat = cell.imgofUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgofUser, radius: CGFloat(someFloat))
            
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 87.0
    }
    
    
    
}

extension UBForwardMessageVC : selectFriendFromListDelegate {
    func friendProfile(cell: GroupCell, indexSelect: IndexPath) {
        
    }
    
    func selectFriend(cell : GroupCell , indexSelect : IndexPath) {
        
        let friendId = self.userFriend?.friendObject?.friendList![indexSelect.row].friend_user_id
        if cell.btnSelect.isSelected == true {
//            self.isSelectedFriend.append(obj!.id!)
            self.friendList.append("\(friendId!)")
        } else {
            if let removeIndex = self.friendList.index(where: {$0 == "\(friendId!)"}) {
                self.friendList.remove(at: removeIndex)
            }
        }
    }
    
}


