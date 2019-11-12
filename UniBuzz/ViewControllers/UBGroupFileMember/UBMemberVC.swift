//
//  UBMemberVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  
protocol DisableActionMemberDelegate : class {
    func memberSelectionDisable()
}

class UBMemberVC: UIViewController {
    var index: Int?
//    friendObject
    
    @IBOutlet weak var tblViewss: UITableView!
    var groupObj : GroupList?
    var userFriend : AllMember?
    var isSelectAllFriendList : Bool?
    var isInviteUser : Bool?
    var isRequest : Bool?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnInvitation: UIButton!
    @IBOutlet weak var btnRequest: UIButton!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var viewOfAllInvitation: UIView!
    var userObj : Session?
    weak var delegate : DisableActionMemberDelegate?
    
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()

        appDelegate.isSelectMember = false
        
        isSelectAllFriendList = true
        isInviteUser = false
        isRequest = false
        
        btnAll.backgroundColor = UIColor(red: 47/255.0, green: 40/255.0, blue: 125/255.0, alpha: 1.0)
        btnInvitation.backgroundColor = UIColor.clear
        btnRequest.backgroundColor = UIColor.clear
        
        btnAll.isSelected = true
        btnInvitation.isSelected = false
        btnRequest.isSelected = false

        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)


        tblViewss.registerCells([
            InviteMemberCell.self , AcceptRejectRequestCell.self
            ])
        getAllMemberOfGroup()
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if isSelectAllFriendList == true {
           getAllMemberOfGroup()
        } else if isInviteUser == true {
            getAllInviteUserOfGroup()
        } else if isRequest == true {
            getAllRequestOfGroup()
        }
//        if isSelectAllFriendList == true {
//            return self.userFriend?.memberList?.groupMember?.count ?? 0
//        } else if isInviteUser == true {
//            return self.userFriend?.inviteUserList?.inviteMemeberList?.count ?? 0
//        } else {
//            return self.userFriend?.requestUserList?.requestList?.count ?? 0
//        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if groupObj?.is_my_group == true {
            viewOfAllInvitation.isHidden = false
        } else {
            viewOfAllInvitation.isHidden = true
        }
    }

    func getAllMemberOfGroup() {
        
        SVProgressHUD.show()
        let groupId = groupObj?.id
        let serviceUrl = "\(FRIENDLISTOFGROUP)\(groupId!)/index"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: AllMember.self, success: {[weak self] (response) in
          guard let this = try? self else {
                return
            }

            this.userFriend = (response as! AllMember)
            this.numberOfPage = this.userFriend?.memberList?.last_page
            this.page = 1
            this.isPageRefreshing = false
            SVProgressHUD.dismiss()

            if this.userFriend?.status == true {

                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                this.refreshControl.endRefreshing()
                this.btnAll.isUserInteractionEnabled = true
                this.btnInvitation.isUserInteractionEnabled = true
                this.btnRequest.isUserInteractionEnabled = true
                this.page = this.page + 1

                this.delegate?.memberSelectionDisable()
            } else {
                this.showAlert(title: KMessageTitle, message: (this.userFriend?.message!)!, controller: self)
                this.delegate?.memberSelectionDisable()

            }
        }) { (error) in
        }
    }
    
    func makeRequest(pageSize : Int)  {
        
        print("page Size \(pageSize)")
        let serviceURL : String?
        let groupId = groupObj?.id

        serviceURL = "\(FRIENDLISTOFGROUP)\(groupId!)/index?page=\(page)"
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: AllMember.self , success: { [weak self] (response) in
            guard let self = self else {return}
            let responeOfPagination = (response as? AllMember)!
            self.numberOfPage = responeOfPagination.memberList?.last_page
            if responeOfPagination.status == true {
                self.isPageRefreshing = false
                DispatchQueue.main.async {
                    for (_ , obj) in ((responeOfPagination.memberList?.groupMember?.enumerated())!) {
                        self.userFriend?.memberList?.groupMember?.append(obj)
                    }
                    self.tblViewss.tableFooterView?.isHidden = true
                    self.activity.stopAnimating()
                    self.tblViewss.reloadData()
                    self.tblViewss.layoutIfNeeded()
                    self.refreshControl.endRefreshing()
                    self.page = self.page + 1
                    
                }
            }
            else
            {
                
            }
        }) { (error) in
        }
    }


    func getAllInviteUserOfGroup() {
        let groupId = groupObj?.id
        
        let serviceUrl = "\(INVITATION)\(groupId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: AllMember.self, success: {[weak self] (response) in
            self!.userFriend = (response as! AllMember)
            if self!.userFriend?.status == true {
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.btnAll.isUserInteractionEnabled = true
                self!.btnInvitation.isUserInteractionEnabled = true
                self!.btnRequest.isUserInteractionEnabled = true


                
            } else {
                self!.showAlert(title: KMessageTitle, message: (self!.userFriend?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    
    func getAllRequestOfGroup() {
        let groupId = groupObj?.id
        let serviceUrl = "\(GROUPREQUEST)\(groupId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: AllMember.self, success: {[weak self] (response) in
            
            self!.userFriend = (response as! AllMember)
            if self!.userFriend?.status == true {
                self!.tblViewss.reloadData()
                self!.btnAll.isUserInteractionEnabled = true
                self!.btnInvitation.isUserInteractionEnabled = true
                self!.btnRequest.isUserInteractionEnabled = true

                self!.refreshControl.endRefreshing()

                //                self.refreshControl.stopAnimating()
            } else {
                self!.showAlert(title: KMessageTitle, message: (self!.userFriend?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    @IBAction func btnAll_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSelectAllFriendList = true
        isInviteUser = false
        isRequest = false
        
        btnAll.backgroundColor = UIColor(red: 47/255.0, green: 40/255.0, blue: 125/255.0, alpha: 1.0)
        btnInvitation.backgroundColor = UIColor.clear
        btnRequest.backgroundColor = UIColor.clear

        btnAll.isSelected = true
        btnInvitation.isSelected = false
        btnRequest.isSelected = false
        
        btnAll.isUserInteractionEnabled = false
        btnInvitation.isUserInteractionEnabled = false
        btnRequest.isUserInteractionEnabled = false

        getAllMemberOfGroup()
    }
    
    @IBAction private func btnInvitation_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected

        isSelectAllFriendList = false
        isInviteUser = true
        isRequest = false
        
        btnInvitation.backgroundColor = UIColor(red: 47/255.0, green: 40/255.0, blue: 125/255.0, alpha: 1.0)
        btnAll.backgroundColor = UIColor.clear
        btnRequest.backgroundColor = UIColor.clear
        
        btnAll.isSelected = false
        btnInvitation.isSelected = true
        btnRequest.isSelected = false
        btnAll.isUserInteractionEnabled = false
        btnInvitation.isUserInteractionEnabled = false
        btnRequest.isUserInteractionEnabled = false

        getAllInviteUserOfGroup()
    }
    
    @IBAction private func btnRequest_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        isSelectAllFriendList = false
        isInviteUser = false
        isRequest = true
        
        btnRequest.backgroundColor = UIColor(red: 47/255.0, green: 40/255.0, blue: 125/255.0, alpha: 1.0)
        btnAll.backgroundColor = UIColor.clear
        btnInvitation.backgroundColor = UIColor.clear
        
        btnAll.isSelected = false
        btnInvitation.isSelected = false
        btnRequest.isSelected = true
        btnAll.isUserInteractionEnabled = false
        btnInvitation.isUserInteractionEnabled = false
        btnRequest.isUserInteractionEnabled = false

        getAllRequestOfGroup()
    }
    
    @IBAction private func btnAddMEmeber_PRessed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddMemberVC") as? UBAddMemberVC
        vc?.groupObj = groupObj
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func acceptRejectRequest(requestId : Int  , serviceUrl : String , index : IndexPath) {
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(serviceUrl)\(requestId)"
        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "Accept OR Reject".localized(), modelType: AllMember.self, success: {[weak self] (responseData) in
            if  let post = responseData as? AllMember {
                if post.status == true {
                    if let index  = self!.userFriend?.requestUserList?.requestList!.index(where: {$0.id == requestId}) {
                        self!.userFriend?.requestUserList?.requestList?.remove(at: index)
                    }
                    self!.tblViewss.reloadData()
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
            //            self.showAlert(title: "OPENSPOT", message: error.description , controller: self)
        }, showHUD: true)
    }
    
    func cancelInvitation(invitationId : Int  , serviceUrl : String , index : IndexPath  , cell : InviteMemberCell) {
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(serviceUrl)\(invitationId)"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "Accept OR Reject".localized(), modelType: AllMember.self, success: {[weak self] (responseData) in
            cell.btnCancel.isUserInteractionEnabled = true
            if  let post = responseData as? AllMember {
                if post.status == true {
                    if let index  = self!.userFriend?.inviteUserList?.inviteMemeberList!.index(where: {$0.id == invitationId}) {
                        self!.userFriend?.inviteUserList?.inviteMemeberList?.remove(at: index)
                    }
                    self!.tblViewss.reloadData()
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
            }, fail: { (error) in
                //            self.showAlert(title: "OPENSPOT", message: error.description , controller: self)
        }, showHUD: true)
    }
}


extension UBMemberVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if isSelectAllFriendList == true  {
              if  self.userFriend?.memberList?.groupMember!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil

            } else  {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Group Member  in your List.".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                self.tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }
        } else if isInviteUser == true {
            if  self.userFriend?.inviteUserList?.inviteMemeberList!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil
                
            }  else  {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Invite Members  in your List.".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }
        } else if  isRequest == true {
            if  self.userFriend?.requestUserList?.requestList!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil
            } else  {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Request List ".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }

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
        if isSelectAllFriendList == true {
            return self.userFriend?.memberList?.groupMember?.count ?? 0

        } else if isInviteUser == true {
            return self.userFriend?.inviteUserList?.inviteMemeberList?.count ?? 0
        } else {
             return self.userFriend?.requestUserList?.requestList?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSelectAllFriendList == true {
            let cell = tableView.dequeueReusableCell(with: GroupCell.self, for: indexPath)
            cell.lblName.text = self.userFriend?.memberList?.groupMember![indexPath.row].user?.full_name
            if self.userFriend?.memberList?.groupMember![indexPath.row].is_admin == true {
                cell.lblIsUserAdmin.isHidden = false
            } else {
                cell.lblIsUserAdmin.isHidden = true
            }
            
            cell.delegate = self
            cell.selectIndex = indexPath
            guard  let image = self.userFriend?.memberList?.groupMember![indexPath.row].user?.profile_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgofUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgofUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgofUser, radius: CGFloat(someFloat))
            return cell

        } else if isInviteUser  ==  true {
            let cell = tableView.dequeueReusableCell(with: InviteMemberCell.self, for: indexPath)
            cell.lblEmail.text = self.userFriend?.inviteUserList?.inviteMemeberList![indexPath.row].email_address
            cell.delegate = self
            cell.indexSelect = indexPath
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(with: AcceptRejectRequestCell.self, for: indexPath)
            cell.lblName.text = self.userFriend?.requestUserList?.requestList![indexPath.row].user?.full_name
            cell.delegate = self
            cell.selectIndex = indexPath
            
            guard  let image = self.userFriend?.requestUserList?.requestList![indexPath.row].user?.profile_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

            return cell

        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 87.0
    }
    
        func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
            if scrollView == tblViewss {
                if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
                    if isPageRefreshing == false {
                        isPageRefreshing = true
                        if page <= numberOfPage! {
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

extension UBMemberVC : CancelInvitationDelegate {
    func cancelInvite(cell: InviteMemberCell, selectIndex: IndexPath) {
        cell.btnCancel.isUserInteractionEnabled = false
        let inviteId = self.userFriend?.inviteUserList?.inviteMemeberList![selectIndex.row].id
        cancelInvitation(invitationId: inviteId!, serviceUrl: CANCELINVITATION, index: selectIndex, cell: cell)
        
    }
}

extension UBMemberVC : AcceptRejectDelegate {
    func acceptRequest(cell : AcceptRejectRequestCell , index : IndexPath) {
        let requestId = self.userFriend?.inviteUserList?.requestList![index.row].id
        acceptRejectRequest(requestId: requestId!, serviceUrl: ACCEPTREQUEST, index: index)
    }
    func rejectRequest(cell : AcceptRejectRequestCell , index : IndexPath) {
        let requestId = self.userFriend?.inviteUserList?.requestList![index.row].id
        acceptRejectRequest(requestId: requestId! , serviceUrl: REJECTREQUESTSS , index : index)

    }

}

extension UBMemberVC : selectFriendFromListDelegate {
    func selectFriend(cell: GroupCell, indexSelect: IndexPath) {
        
    }
    
    func friendProfile(cell : GroupCell , indexSelect : IndexPath) {
        if self.userFriend?.memberList?.groupMember![indexSelect.row].user_id == userObj?.id {
            
        }
        else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
            if #available(iOS 10.0 , *)  {
                vc?.modalPresentationStyle = .overCurrentContext
            } else {
                vc?.modalPresentationStyle = .currentContext
            }
            vc?.userInfo = self.userFriend?.memberList?.groupMember![indexSelect.row].user
            vc?.providesPresentationContextTransitionStyle = true
            present(vc!, animated: true) {
                
            }
        }
            
        


    }
}
