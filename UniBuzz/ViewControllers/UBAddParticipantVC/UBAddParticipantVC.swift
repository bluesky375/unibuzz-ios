//
//  UBAddParticipantVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
//protocol AddParticipantDelegat : class {
//    func addUser(part : [GroupChatMember])
//}

class UBAddParticipantVC: UIViewController {
    
   private  var responseObj : UserResponse?
   @IBOutlet weak var tblViewss: UITableView!
    var selectGroupOrUser : ChatList?
    private var isSelectedFriend  : [Int] = []
    var friendList : [FriendProfile]?
//    weak var delegate : AddParticipantDelegat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendList = []
        getAllParticipant()
        // Do any additional setup after loading the view.
    }
    
    
    func getAllParticipant() {
//        let serviceUrl = CVGET
        
        let groupId = selectGroupOrUser?.id
        let serviceUrl = "\(FRIENDADD)\(groupId!)/friends"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Get Participant".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let this = self else {
                return
            }
            this.responseObj = (response as? UserResponse)
            if this.responseObj!.status == true {
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
            } else {
                self!.showAlert(title: KMessageTitle, message: this.responseObj!.message!, controller: self)
            }
        }) { (error) in
        }
    }
    
    @IBAction private func btnAddParticipant_Pressed(_ sender : UIButton) {
        
        if isSelectedFriend.count > 0 {
            var param = [:] as [String : Any]
            let groupId = selectGroupOrUser?.id
            param = ["group_id"                   :  "\(groupId!)",
                      "members"                    :   isSelectedFriend
                    ]
            WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: ADDMEMBERSINGROUP , serviceType: "Login".localized(), modelType: UserResponse.self, success: { [weak self] (responseData) in
                if  let post = responseData as? UserResponse {
                    if post.status == true {
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("addParticipant"), object: nil)
                    self!.showAlertViewWithTitle(title: KMessageTitle, message: post.message! , dismissCompletion: {
            //                  self?.delegate?.addUser(part: post.addParticipant!)
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
            self.showAlert(title: KMessageTitle, message: "Select friend for add ".localized(), controller: self)
        }

    }
    
}

extension UBAddParticipantVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  responseObj?.addMember!.isEmpty == false {
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
        return responseObj?.addMember?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: GroupCell.self, for: indexPath)
        cell.lblName.text = responseObj?.addMember![indexPath.row].full_name
        cell.lblGroupName.text = ""
        if isSelectedFriend.contains((responseObj?.addMember![indexPath.row].id)!) {
            cell.btnSelect.isSelected = true
        } else {
            cell.btnSelect.isSelected = false
        }
        
        cell.delegate = self
        cell.selectIndex = indexPath
        
//        if self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name != nil {
//            cell.lblGroupName.text = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name
//        } else {
//            cell.lblGroupName.text = ""
//        }
        guard  let image = responseObj?.addMember![indexPath.row].profile_image  else   {
            return cell
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgofUser!), placeHolder: "profile2")
        let cgFloat: CGFloat = cell.imgofUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(cell.imgofUser, radius: CGFloat(someFloat))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 87.0
    }
    
    
    
}

extension UBAddParticipantVC : selectFriendFromListDelegate  {
    func friendProfile(cell: GroupCell, indexSelect: IndexPath) {
        
    }
    
    
    func selectFriend(cell : GroupCell , indexSelect : IndexPath) {
        let obj = self.responseObj?.addMember![indexSelect.row]
        if cell.btnSelect.isSelected == true {
            self.isSelectedFriend.append(obj!.id!)
            friendList?.append(obj!)
        } else {
            if let index  = self.friendList?.index(where: {$0.id == obj?.id}) {
                self.friendList?.remove(at: index)
            }
            if let removeIndex = self.isSelectedFriend.index(where: {$0 == obj?.id}) {
                self.isSelectedFriend.remove(at: removeIndex)
            }
        }
    }
    
}
